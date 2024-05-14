# Copyright 2024 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rubyexec.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @DESCRIPTION:
# This eclass provides helper functions for installing gem binaries
# with rubyexec as their ruby implementation selector.

[[ ${EAPI} == [5678] ]] || die "EAPI needs to be 5, 6, 7 or 8."

inherit is-var-true

# @ECLASS_VARIABLE: RUBYEXEC_SKIP_RUBYEXEC_IF_ONE_IMPL
# @DESCRIPTION:
# Whether to place the Ruby implmentation directly on the shebang header
# if there's only one effective implementation to install binaries for.
# Default value is "true".
: ${RUBYEXEC_SKIP_RUBYEXEC_IF_ONE_IMPL=true}

# @FUNCTION: _rubyexec-all_files_the_same
# @DESCRIPTION:
# Checks if all specified files are the same.
# @RETURN: OK status (0) if all files match, or FAIL status (1) otherwise
# @INTERNAL
_rubyexec-all_files_the_same() {
	local first=$1 x
	shift

	for x; do
		cmp -s -- "${first}" "${x}" || return 1
	done

	return 0
}

# @FUNCTION: _rubyexec-priority_sort_impls
# @DESCRIPTION:
# Prioritizes newer ruby?? implementations
# @INTERNAL
_rubyexec-priority_sort_impls() {
	local impl i
	_sorted_impls=("$1")
	shift

	for impl; do
		if [[ ${impl} == ruby[0-9][0-9] ]]; then
			for i in "${!_sorted_impls[@]}"; do
				if [[ ${_sorted_impls[i]} != ruby[0-9][0-9] ||
						${impl} > "${_sorted_impls[i]}" ]]; then
					_sorted_impls=("${impl}" "${_sorted_impls[@]}")
					continue 2
				fi
			done
		fi

		_sorted_impls+=("${impl}")
	done
}

# @FUNCTION: rubyexec-install_fakegem_binaries
# @DESCRIPTION:
# This either copies raw binary files to /usr/bin with their #! header
# modified or use ruby_fakegem_binwrapper to create a wrapper binary and
# modify that binary's header depending on whether all versions of raw
# binaries are the same or not.
#
# The all_fakegem_install function still has to be called before or
# after calling this function and RUBY_FAKEGEM_BINWRAP needs to be set
# to an empty value before calling it.
rubyexec-install_fakegem_binaries() {
	local all_binaries autopick=false bindirs content final_new_header gem_base gem_binary \
			globstar_was_enabled=false impls new_header relative_bindir rubyexec_arg temp \
			_sorted_impls

	if [[ $1 == --autopick ]]; then
		autopick=true
		shift
	fi

	shopt -q globstar && globstar_was_enabled=true
	shopt -s globstar || die "Failed to enable globstar."

	relative_bindir="gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/${RUBY_FAKEGEM_BINDIR}"
	bindirs=("${D}/"**"/${relative_bindir}")

	impls=($(ruby_get_use_implementations)) && [[ ${impls+.} ]] || \
		die "Failed to get implementations."
	[[ ${#impls[@]} -eq "${#bindirs[@]}" ]] || \
		die "Number of implementations don't match bindirs."

	# Use the ruby implementation directly if there's only one

	if [[ ${#impls[@]} -eq 1 ]] && is_var_true RUBYEXEC_SKIP_RUBYEXEC_IF_ONE_IMPL; then
		new_header="#!/usr/bin/ruby${impls}"
	else
		if [[ ${autopick} == true ]]; then
			_rubyexec-priority_sort_impls "${impls[@]}"
			printf -v rubyexec_arg '%s,' "${_sorted_impls[@]}"
			rubyexec_arg+=--autopick
		else
			printf -v rubyexec_arg '%s,' "${impls[@]}"
			rubyexec_arg=${rubyexec_arg%,}
		fi

		new_header="#!/usr/bin/rubyexec ${rubyexec_arg}"
	fi

	for gem_binary in "${bindirs}"/*; do
		gem_base=${gem_binary##*/}
		all_binaries=("${bindirs[@]/%//${gem_base}}")
		temp=${T}/rubyexec-bin-${gem_base}

		[[ ${#all_binaries[@]} -eq ${#impls[@]} ]] || \
			die "Number of matched binaries don't match implementations."

		# Copy the binary itself if it's a script and is identical in all
		# versions.

		# Special shebang handling feature of Ruby also can only be supported if
		# scripts are identical.

		if [[ ${#impls[@]} -eq 1 ]] || _rubyexec-all_files_the_same "${all_binaries[@]}" &&
				IFS=$' \t' read -ra old_header -n128 < "${gem_binary}" &&
				[[ ${old_header} == *"#!"* ]]; then
			if [[ ${old_header} == *ruby* ]]; then
				final_new_header="${new_header} ${old_header[*]:1}"
			elif [[ ${old_header} == "#!" && ${old_header[1]} == *ruby* ]]; then
				final_new_header="${new_header} ${old_header[*]:2}"
			else
				final_new_header=${new_header}
			fi

			content=() # Just make sure it's cleared.
			readarray -s1 -t content < "${bindirs}/${gem_base}" || \
				die "Failed to read '${bindirs}/${gem_base}'."
			printf '%s\n' "${final_new_header}" "${content[@]/%$'\r'}" > "${temp}" || \
				die "Failed to create modified binary."
			rm "${all_binaries[@]}" || die "Failed to remove binaries."
		else
			cat - > "${temp}" <<EOF
${new_header}
#
# Generated by rubyexec.eclass
#

load RbConfig::CONFIG['sitelibdir'].gsub('site_ruby', 'gems') + "/${relative_bindir}/${gem_base}"
EOF

			ruby_fakegem_binwrapper "${gem_base}"
		fi

		exeinto /usr/bin
		newexe "${temp}" "${gem_base}"
	done

	[[ ${globstar_was_enabled} == false ]] && shopt -u globstar
}
