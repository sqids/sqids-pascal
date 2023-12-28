program testsqids;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  sqids in '..\..\src\sqids.pas',
  common in 'common.pas',
  alphabet in 'alphabet.pas',
  blocklist in 'blocklist.pas',
  encoding in 'encoding.pas',
  minlength in 'minlength.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

