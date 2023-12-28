unit minlength;

{$mode delphi}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, sqids, common;

type

  { TTestMinLength }

  TTestMinLength = class(TTestCase)
  published
    procedure Simple;
    procedure Incremental;
    procedure IncrementalNumbers;
    procedure MinLengths;
    // out-of-range MinLength test not implemented:
    // compiler enforces MinLength to be within range of a Byte
  end;

implementation

procedure TTestMinLength.Simple;
const
  Numbers: TNumbers = [1,2,3];
  Id = '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM';
begin
  with TSqids.Create(DEFAULT_ALPHABET.Length) do
  try
    AssertEquals(Encode(Numbers), Id);
    AssertTrue(Decode(Id).Equals(Numbers));
  finally
    Free;
  end;
end;

procedure TTestMinLength.Incremental;
const
  Numbers: TNumbers = [1,2,3];
  Pairs: array of TMinLenIdPair = [
    (MinLen: 6;  Id: '86Rf07'),
    (MinLen: 7;  Id: '86Rf07x'),
    (MinLen: 8;  Id: '86Rf07xd'),
    (MinLen: 9;  Id: '86Rf07xd4'),
    (MinLen: 10; Id: '86Rf07xd4z'),
    (MinLen: 11; Id: '86Rf07xd4zB'),
    (MinLen: 12; Id: '86Rf07xd4zBm'),
    (MinLen: 13; Id: '86Rf07xd4zBmi'),
    (MinLen: {DEFAULT_ALPHABET.Length} 62 + 0; Id: '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM'),
    (MinLen: {DEFAULT_ALPHABET.Length} 62 + 1; Id: '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMy'),
    (MinLen: {DEFAULT_ALPHABET.Length} 62 + 2; Id: '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf'),
    (MinLen: {DEFAULT_ALPHABET.Length} 62 + 3; Id: '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf1')
  ];
var
  Pair: TMinLenIdPair;
begin
  for Pair in Pairs do
    with TSqids.Create(Pair.MinLen) do
    try
      AssertEquals(Encode(Numbers), Pair.Id);
      AssertEquals(Encode(Numbers).Length, Pair.MinLen);
      AssertTrue(Decode(Pair.Id).Equals(Numbers));
    finally
      Free;
    end;
end;

procedure TTestMinLength.IncrementalNumbers;
const
  Pairs: array of TIdNumbersPair = [
    (Id: 'SvIzsqYMyQwI3GWgJAe17URxX8V924Co0DaTZLtFjHriEn5bPhcSkfmvOslpBu'; Numbers: [0, 0]),
    (Id: 'n3qafPOLKdfHpuNw3M61r95svbeJGk7aAEgYn4WlSjXURmF8IDqZBy0CT2VxQc'; Numbers: [0, 1]),
    (Id: 'tryFJbWcFMiYPg8sASm51uIV93GXTnvRzyfLleh06CpodJD42B7OraKtkQNxUZ'; Numbers: [0, 2]),
    (Id: 'eg6ql0A3XmvPoCzMlB6DraNGcWSIy5VR8iYup2Qk4tjZFKe1hbwfgHdUTsnLqE'; Numbers: [0, 3]),
    (Id: 'rSCFlp0rB2inEljaRdxKt7FkIbODSf8wYgTsZM1HL9JzN35cyoqueUvVWCm4hX'; Numbers: [0, 4]),
    (Id: 'sR8xjC8WQkOwo74PnglH1YFdTI0eaf56RGVSitzbjuZ3shNUXBrqLxEJyAmKv2'; Numbers: [0, 5]),
    (Id: 'uY2MYFqCLpgx5XQcjdtZK286AwWV7IBGEfuS9yTmbJvkzoUPeYRHr4iDs3naN0'; Numbers: [0, 6]),
    (Id: '74dID7X28VLQhBlnGmjZrec5wTA1fqpWtK4YkaoEIM9SRNiC3gUJH0OFvsPDdy'; Numbers: [0, 7]),
    (Id: '30WXpesPhgKiEI5RHTY7xbB1GnytJvXOl2p0AcUjdF6waZDo9Qk8VLzMuWrqCS'; Numbers: [0, 8]),
    (Id: 'moxr3HqLAK0GsTND6jowfZz3SUx7cQ8aC54Pl1RbIvFXmEJuBMYVeW9yrdOtin'; Numbers: [0, 9])
  ];
var
  Pair: TIdNumbersPair;
begin
  with TSqids.Create(DEFAULT_ALPHABET.Length) do
  try
    for Pair in Pairs do
    begin
      AssertEquals(Encode(Pair.Numbers), Pair.Id);
      AssertTrue(Decode(Pair.Id).Equals(Pair.Numbers));
    end;
  finally
    Free;
  end;
end;

procedure TTestMinLength.MinLengths;
const
  NumbersList: array of TNumbers = [
		[0],
		[0, 0, 0, 0, 0],
		[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		[100, 200, 300],
		[1000, 2000, 3000],
		[1000000],
		[High(TNumber)]
  ];
var
  Id: string;
  Numbers: TNumbers;
  MinLength: Byte;
begin
  for MinLength in [0, 1, 5, 10, DEFAULT_ALPHABET.Length] do
    with TSqids.Create(MinLength) do
    try
      for Numbers in NumbersList do
      begin
        Id := Encode(Numbers);
        AssertTrue(Id.Length >= MinLength);
        AssertTrue(Decode(Id).Equals(Numbers));
      end;
    finally
      Free;
    end;
end;

initialization
  RegisterTest(TTestMinLength);

end.

