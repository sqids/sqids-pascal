unit common;

interface

uses sqids;

type
  TIdNumbersPair = record
    Id: string;
    Numbers: TNumbers;
  end;

  TMinLenIdPair = record
    MinLen: Byte;
    Id: string;
  end;

  { TNumbersHelper }

  TNumbersHelper = record helper for TNumbers
  public
    function Equals(ANumbers: TNumbers): Boolean;
  end;

implementation

{ TNumbersHelper }

function TNumbersHelper.Equals(ANumbers: TNumbers): Boolean;
var
  I: Integer;
begin
  if Length(Self) <> Length(ANumbers) then
    Exit(False);

  for I := 0 to High(Self) do
    if Self[I] <> ANumbers[I] then
      Exit(False);

  Result := True;
end;

end.
