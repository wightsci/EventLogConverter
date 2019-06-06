# EventLogConverter

A script to take Windows Event Log entries and make them easier to query and generally mine data from.

## What does this do?

The idea is to take the nested data structures of a typical Windows Event and make them flat, so that all of the useful properties are easily accessible via standard
PowerShell techniques, such as ``Where-Object``, ``Group-Object`` and ``Select-Object``.

Given the many varied log structures used by the Windows Event log, some compromises have had to be made.