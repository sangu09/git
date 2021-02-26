#!/bin/sh

test_description='Tests rename detection performance'
. ./perf-lib.sh

test_perf_default_repo

test_expect_success 'setup rebase on renaming git repository' '
	git reset --hard &&
	git switch -c 2.29-renames v2.29.0 &&
	git mv builtin cmds &&
	git commit -m "Rename builtin/ to cmds/" &&
	git config merge.renameLimit 30000 &&
	git config merge.directoryRenames true &&
	git branch -f fsmonitor 1c6833c800ad98adecd85815db103cfd4d06c50a &&
	git branch -f fsmonitor_base 430cabb104103251958ac0739509e0a542e5c774
'

test_perf 'rebase on top of fsmonitor' '
	git rebase --onto HEAD fsmonitor_base fsmonitor
'

test_done