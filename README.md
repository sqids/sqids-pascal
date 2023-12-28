# [Sqids Pascal](https://sqids.org/pascal)

[Sqids](https://sqids.org/pascal) (*pronounced "squids"*) is a small library that lets you **generate unique IDs from numbers**. It's good for link shortening, fast & URL-safe ID generation and decoding back into numbers for quicker database lookups.

Features:

- **Encode multiple numbers** - generate short IDs from one or several non-negative numbers
- **Quick decoding** - easily decode IDs back into numbers
- **Unique IDs** - generate unique IDs by shuffling the alphabet once
- **ID padding** - provide minimum length to make IDs more uniform
- **URL safe** - auto-generated IDs do not contain common profanity
- **Randomized output** - Sequential input provides nonconsecutive IDs
- **Many implementations** - Support for [multiple programming languages](https://sqids.org/)

## 🧰 Use-cases

Good for:

- Generating IDs for public URLs (eg: link shortening)
- Generating IDs for internal systems (eg: event tracking)
- Decoding for quicker database lookups (eg: by primary keys)

Not good for:

- Sensitive data (this is not an encryption library)
- User IDs (can be decoded revealing user count)

## 🚀 Getting started

#### Free Pascal/Lazarus:
  * FPC ≥ 3.2.0 required (because array operators are used).
  * Clone or download this repository and compile the package **sqidspkg.lpk**.
  * Add **sqidspkg** to the Required Packages of your application.
  
#### Delphi:
  * Tested with Delphi 11, should work with Delphi ≥ XE7 (which introduced string-like operations on dynamic arrays).
  * Clone or download this repository.
  * Add the **src** subfolder to your project's search path.

## 👩‍💻 Examples

Simple encode & decode:

```pascal
var
  Id: string;
  Numbers: TNumbers;
begin
  with TSqids.Create do
  try
    Id := Encode([1, 2, 3]); // '86Rf07'
    Numbers := Decode(Id); // [1, 2, 3]
  finally
    Free;
  end;
end;
```

> **Note**
> 🚧 Because of the algorithm's design, **multiple IDs can decode back into the same sequence of numbers**. If it's important to your design that IDs are canonical, you have to manually re-encode decoded numbers and check that the generated ID matches.

Encoding & decoding just one number:

```pascal
var
  Id: string;
  Number: TNumber;
begin
  with TSqids.Create do
  try
    Id := EncodeSingle(1); // 'Uk'
    Number := DecodeSingle(Id); // 1
  finally
    Free;
  end;
end;
```

Enforce a *minimum* length for IDs:

```pascal
var
  Id: string;
begin
  with TSqids.Create(10) do
  try
    Id := Encode([1, 2, 3]); // '86Rf07xd4z'
  finally
    Free;
  end;
end;
```

Randomize IDs by providing a custom alphabet:

```pascal
var
  Id: string;
begin
  with TSqids.Create('FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE') do
  try
    Id := Encode([1, 2, 3]); // 'B4aajs'
  finally
    Free;
  end;
end;
```

Prevent specific words from appearing anywhere in the auto-generated IDs:

```pascal
var
  Id: string;
begin
  with TSqids.Create(['86Rf07']) do
  try
    Id := Encode([1, 2, 3]); // 'se8ojk'
  finally
    Free;
  end;
end;
```

## 📝 License

[MIT](LICENSE)
