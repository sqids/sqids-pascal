unit encoding;

interface

uses
  TestFramework, sqids, common;

type

  { TTestEncoding }

  TTestEncoding = class(TTestCase)
  published
    procedure Simple;
    procedure DifferentInputs;
    procedure IncrementalNumbers;
    procedure IncrementalNumbersSameIndex0;
    procedure IncrementalNumbersSameIndex1;
    procedure MultiInput;
    procedure NoNumbers;
    procedure EmptyString;
    procedure IdWithInvalidCharacter;
    // out-of-range test not implemented:
    // compiler enforces that all numbers are within the range of a TNumber
  end;

implementation

procedure TTestEncoding.Simple;
const
  Numbers: TNumbers = [1,2,3];
  Id = '86Rf07';
begin
  with TSqids.Create do
  try
    CheckEquals(Encode(Numbers), Id);
    CheckTrue(Decode(Id).Equals(Numbers));
  finally
    Free;
  end;
end;

procedure TTestEncoding.DifferentInputs;
const
  // Delphi gives EIntOverflow error when using High(TNumber),
  // therefore we use High(TNumber) - 1.
  // Free Pascal handels High(TNumber) just fine.
  Numbers: TNumbers = [0,0,0,1,2,3,100,1000,100000,1000000,High(TNumber)-1];
begin
  with TSqids.Create do
  try
    CheckTrue(Decode(Encode(Numbers)).Equals(Numbers));
  finally
    Free;
  end;
end;

procedure TTestEncoding.IncrementalNumbers;
const
  Pairs: array[0..9] of TIdNumbersPair = (
    (Id: 'bM'; Numbers: [0]),
    (Id: 'Uk'; Numbers: [1]),
    (Id: 'gb'; Numbers: [2]),
    (Id: 'Ef'; Numbers: [3]),
    (Id: 'Vq'; Numbers: [4]),
    (Id: 'uw'; Numbers: [5]),
    (Id: 'OI'; Numbers: [6]),
    (Id: 'AX'; Numbers: [7]),
    (Id: 'p6'; Numbers: [8]),
    (Id: 'nJ'; Numbers: [9])
  );
var
  Pair: TIdNumbersPair;
begin
  with TSqids.Create do
  try
    for Pair in Pairs do
    begin
      CheckEquals(Encode(Pair.Numbers), Pair.Id);
      CheckTrue(Decode(Pair.Id).Equals(Pair.Numbers));
    end;
  finally
    Free;
  end;
end;

procedure TTestEncoding.IncrementalNumbersSameIndex0;
const
  Pairs: array[0..9] of TIdNumbersPair = (
    (Id: 'SvIz'; Numbers: [0, 0]),
    (Id: 'n3qa'; Numbers: [0, 1]),
    (Id: 'tryF'; Numbers: [0, 2]),
    (Id: 'eg6q'; Numbers: [0, 3]),
    (Id: 'rSCF'; Numbers: [0, 4]),
    (Id: 'sR8x'; Numbers: [0, 5]),
    (Id: 'uY2M'; Numbers: [0, 6]),
    (Id: '74dI'; Numbers: [0, 7]),
    (Id: '30WX'; Numbers: [0, 8]),
    (Id: 'moxr'; Numbers: [0, 9])
  );
var
  Pair: TIdNumbersPair;
begin
  with TSqids.Create do
  try
    for Pair in Pairs do
    begin
      CheckEquals(Encode(Pair.Numbers), Pair.Id);
      CheckTrue(Decode(Pair.Id).Equals(Pair.Numbers));
    end;
  finally
    Free;
  end;
end;

procedure TTestEncoding.IncrementalNumbersSameIndex1;
const
  Pairs: array[0..9] of TIdNumbersPair = (
    (Id: 'SvIz'; Numbers: [0, 0]),
    (Id: 'nWqP'; Numbers: [1, 0]),
    (Id: 'tSyw'; Numbers: [2, 0]),
    (Id: 'eX68'; Numbers: [3, 0]),
    (Id: 'rxCY'; Numbers: [4, 0]),
    (Id: 'sV8a'; Numbers: [5, 0]),
    (Id: 'uf2K'; Numbers: [6, 0]),
    (Id: '7Cdk'; Numbers: [7, 0]),
    (Id: '3aWP'; Numbers: [8, 0]),
    (Id: 'm2xn'; Numbers: [9, 0])
  );
var
  Pair: TIdNumbersPair;
begin
  with TSqids.Create do
  try
    for Pair in Pairs do
    begin
      CheckEquals(Encode(Pair.Numbers), Pair.Id);
      CheckTrue(Decode(Pair.Id).Equals(Pair.Numbers));
    end;
  finally
    Free;
  end;
end;

procedure TTestEncoding.MultiInput;
const
  Numbers: TNumbers = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
		26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
		50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73,
		74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
		98, 99
  ];
begin
  with TSqids.Create do
  try
    CheckTrue(Decode(Encode(Numbers)).Equals(Numbers));
  finally
    Free;
  end;
end;

procedure TTestEncoding.NoNumbers;
begin
  with TSqids.Create do
  try
    CheckEquals(Encode([]), '');
  finally
    Free;
  end;
end;

procedure TTestEncoding.EmptyString;
begin
  with TSqids.Create do
  try
    CheckTrue(Decode('').Equals([]));
  finally
    Free;
  end;
end;

procedure TTestEncoding.IdWithInvalidCharacter;
begin
  with TSqids.Create do
  try
    CheckTrue(Decode('*').Equals([]));
  finally
    Free;
  end;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TTestEncoding.Suite);
end.
