{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ModelParamsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ModelParamsIntf,
    InjectableObjectImpl,
    KeyValueMapImpl,
    KeyIntValueMapImpl;

type

    (*!------------------------------------------------
     * store model parameter data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TModelParams = class (TInjectableObject, IModelParams)
    private
        fKeyValue : TKeyValueMap;
        fKeyIntValue : TKeyIntValueMap;
    public
        constructor create();
        destructor destroy(); override;

        function writeString(const key : shortstring; const value : string) : IModelParams; overload;
        function writeInteger(const key : shortstring; const value : integer) : IModelParams; overload;

        function readString(const key : shortstring) : string; overload;
        function readInteger(const key : shortstring) : integer; overload;
    end;

implementation

    constructor TModelParams.create();
    begin
        fKeyValue := TKeyValueMap.create();
        fKeyIntValue := TKeyIntValueMap.create();
    end;

    destructor TModelParams.destroy();
    begin
        fKeyValue.free();
        fKeyIntValue.free();
        inherited destroy();
    end;

    function TModelParams.writeString(const key : shortstring; const value : string) : IModelParams; overload;
    begin
        fKeyValue[key] := value;
        result := self;
    end;

    function TModelParams.writeInteger(const key : shortstring; const value : integer) : IModelParams; overload;
    begin
        fKeyIntValue[key] := value;
        result := self;
    end;

    function TModelParams.readString(const key : shortstring) : string; overload;
    begin
        result := fKeyValue[key];
    end;

    function TModelParams.readInteger(const key : shortstring) : integer; overload;
    begin
        result := fKeyIntValue[key];
    end;

end.
