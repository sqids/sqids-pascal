unit blocklist;

interface

uses
  TestFramework, sqids, common;

type

  { TTestBlockList }

  TTestBlockList = class(TTestCase)
  private
    procedure DoMaxEncodingAttemts;
  published
    procedure DefaultBlockList;
    procedure EmptyBlockList;
    procedure OverrideDefaultBlockList;
    procedure BlockList;
    procedure DecodingBlocklistWords;
    procedure ShortBlockListWords;
    procedure BlockListFiltering;
    procedure MaxEncodingAttemts;
  end;

implementation

procedure TTestBlockList.DefaultBlockList;
begin
  with TSqids.Create do
  try
    CheckTrue(Decode('aho1e').Equals([4572721]));
    CheckEquals(Encode([4572721]), 'JExTR');
  finally
    Free;
  end;
end;

procedure TTestBlockList.EmptyBlockList;
begin
  with TSqids.Create([]) do
  try
    CheckTrue(Decode('aho1e').Equals([4572721]));
    CheckEquals(Encode([4572721]), 'aho1e');
  finally
    Free;
  end;
end;

procedure TTestBlockList.OverrideDefaultBlockList;
begin
  with TSqids.Create(['ArUO']) do // originally encoded [100000]
  try
    // make sure we don't use the default blocklist
    CheckTrue(Decode('aho1e').Equals([4572721]));
    CheckEquals(Encode([4572721]), 'aho1e');

    // make sure we are using the passed blocklist
    CheckTrue(Decode('ArUO').Equals([100000]));
    CheckEquals(Encode([100000]), 'QyG4');
    CheckTrue(Decode('QyG4').Equals([100000]));
  finally
    Free;
  end;
end;

procedure TTestBlockList.BlockList;
begin
  with TSqids.Create([
    'JSwXFaosAN', // normal result of 1st encoding, let's block that word on purpose
    'OCjV9JK64o', // result of 2nd encoding
		'rBHf', // result of 3rd encoding is `4rBHfOiqd3`, let's block a substring
		'79SM', // result of 4th encoding is `dyhgw479SM`, let's block the postfix
		'7tE6' // result of 4th encoding is `7tE6jdAHLe`, let's block the prefix
  ]) do
  try
    CheckEquals(Encode([1000000,2000000]), '1aYeB7bRUt');
    CheckTrue(Decode('1aYeB7bRUt').Equals([1000000,2000000]));
  finally
    Free;
  end;
end;

procedure TTestBlockList.DecodingBlocklistWords;
begin
  with TSqids.Create(['86Rf07', 'se8ojk', 'ARsz1p', 'Q8AI49', '5sQRZO']) do
  try
    CheckTrue(Decode('86Rf07').Equals([1,2,3]));
    CheckTrue(Decode('se8ojk').Equals([1,2,3]));
    CheckTrue(Decode('ARsz1p').Equals([1,2,3]));
    CheckTrue(Decode('Q8AI49').Equals([1,2,3]));
    CheckTrue(Decode('5sQRZO').Equals([1,2,3]));
  finally
    Free;
  end;
end;

procedure TTestBlockList.ShortBlockListWords;
begin
  with TSqids.Create(['pnd']) do
  try
    CheckTrue(Decode(Encode([1000])).Equals([1000]));
  finally
    Free;
  end;
end;

procedure TTestBlockList.BlockListFiltering;
var
  Id: string;
  Numbers: TNumbers;
begin
  with TSqids.Create(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    0,
    ['sxnzkl'] // lowercase blocklist in only-uppercase alphabet
  ) do
  try
    Id := Encode([1,2,3]);
    Numbers := Decode(Id);

    CheckEquals(Id, 'IBSHOZ'); // without blocklist, would've been "SXNZKL"
    CheckTrue(Numbers.Equals([1,2,3]));
  finally
    Free;
  end;
end;

procedure TTestBlockList.DoMaxEncodingAttemts;
begin
  with TSqids.Create(
    'abc',
    3,
    ['cab','abc','bca']
  ) do
  try
    Encode([0]);
  finally
    Free;
  end;
end;

procedure TTestBlockList.MaxEncodingAttemts;
begin
  CheckException(DoMaxEncodingAttemts, ESqidsException);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TTestBlockList.Suite);
end.
