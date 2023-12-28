unit alphabet;

interface

uses
  TestFramework, sqids, common;

type

  { TTestAlphabet }

  TTestAlphabet = class(TTestCase)
  private
    procedure DoMultiByteCharacters;
    procedure DoRepeatingAlphabetCharacters;
    procedure DoAlphabetTooShort;
  published
    procedure Simple;
    procedure ShortAlphabet;
    procedure LongAlphabet;
    procedure MultiByteCharacters;
    procedure RepeatingAlphabetCharacters;
    procedure AlphabetTooShort;
  end;

implementation

procedure TTestAlphabet.Simple;
const
  Numbers: TNumbers = [1,2,3];
  Id = '489158';
begin
  with TSqids.Create('0123456789abcdef') do
  try
    CheckEquals(Encode(Numbers), Id);
    CheckTrue(Decode(Id).Equals(Numbers));
  finally
    Free;
  end;
end;

procedure TTestAlphabet.ShortAlphabet;
const
  Numbers: TNumbers = [1,2,3];
begin
  with TSqids.Create('abc') do
  try
    CheckTrue(Decode(Encode(Numbers)).Equals(Numbers));
  finally
    Free;
  end;
end;
procedure TTestAlphabet.LongAlphabet;
const
  Numbers: TNumbers = [1,2,3];
begin
  with TSqids.Create('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+|{}[];:\''"/?.>,<`~') do
  try
    CheckTrue(Decode(Encode(Numbers)).Equals(Numbers));
  finally
    Free;
  end;
end;
procedure TTestAlphabet.DoMultiByteCharacters;
begin
  with TSqids.Create('ë1092') do Free;
end;
procedure TTestAlphabet.MultiByteCharacters;
begin
  CheckException(DoMultiByteCharacters, ESqidsException);
end;
procedure TTestAlphabet.DoRepeatingAlphabetCharacters;
begin
  with TSqids.Create('aabcdefg') do Free;
end;
procedure TTestAlphabet.RepeatingAlphabetCharacters;
begin
  CheckException(DoRepeatingAlphabetCharacters, ESqidsException);
end;
procedure TTestAlphabet.DoAlphabetTooShort;
begin
  with TSqids.Create('ab') do Free;
end;
procedure TTestAlphabet.AlphabetTooShort;
begin
  CheckException(DoAlphabetTooShort, ESqidsException);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TTestAlphabet.Suite);
end.

