unit alphabet;

{$mode delphi}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, sqids, common;

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
    AssertEquals(Encode(Numbers), Id);
    AssertTrue(Decode(Id).Equals(Numbers));
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
    AssertTrue(Decode(Encode(Numbers)).Equals(Numbers));
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
    AssertTrue(Decode(Encode(Numbers)).Equals(Numbers));
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
  AssertException(ESqidsException, DoMultiByteCharacters, 'Alphabet cannot contain multibyte characters');
end;

procedure TTestAlphabet.DoRepeatingAlphabetCharacters;
begin
  with TSqids.Create('aabcdefg') do Free;
end;

procedure TTestAlphabet.RepeatingAlphabetCharacters;
begin
  AssertException(ESqidsException, DoRepeatingAlphabetCharacters, 'Alphabet must contain unique characters');
end;

procedure TTestAlphabet.DoAlphabetTooShort;
begin
  with TSqids.Create('ab') do Free;
end;

procedure TTestAlphabet.AlphabetTooShort;
begin
  AssertException(ESqidsException, DoAlphabetTooShort, 'Alphabet length must be at least 3');
end;

initialization
  RegisterTest(TTestAlphabet);

end.

