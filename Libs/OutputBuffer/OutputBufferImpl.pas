{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit OutputBufferImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    classes,
    DependencyIntf,
    OutputBufferIntf;

type

    (*!------------------------------------------------
     * class having capability to buffer
     * standard output to a storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TOutputBuffer = class(TInterfacedObject, IOutputBuffer, IDependency)
    private
        originalStdOutput, streamStdOutput: TextFile;
        stream : TStringStream;
        isBuffering : boolean;
    public
        constructor create();
        destructor destroy(); override;

        {------------------------------------------------
         begin output buffering
        -----------------------------------------------}
        function beginBuffering() : IOutputBuffer;

        {------------------------------------------------
         end output buffering
        -----------------------------------------------}
        function endBuffering() : IOutputBuffer;

        {------------------------------------------------
         read output buffer content
        -----------------------------------------------}
        function read() : string;

        {------------------------------------------------
         read output buffer content and empty the buffer
        -----------------------------------------------}
        function flush() : string;

        {------------------------------------------------
         read content length
        -----------------------------------------------}
        function size() : int64;
    end;

implementation

uses
    streamIO;

    constructor TOutputBuffer.create();
    begin
        stream := TStringStream.create('');
        isBuffering := false;
    end;

    destructor TOutputBuffer.destroy();
    begin
        inherited destroy();
        isBuffering := false;
        stream.free();
    end;

    {------------------------------------------------
     begin output buffering
    -----------------------------------------------}
    function TOutputBuffer.beginBuffering() : IOutputBuffer;
    begin
        if (not isBuffering) then
        begin
            isBuffering := true;
            stream.size := 0;
            AssignStream(streamStdOutput, stream);
            Rewrite(streamStdOutput);
            //save original standard output, we can restore it
            originalStdOutput := Output;
            Output := streamStdOutput;
        end;
        result := self;
    end;

    {------------------------------------------------
     end output buffering
    -----------------------------------------------}
    function TOutputBuffer.endBuffering() : IOutputBuffer;
    begin
        if (isBuffering) then
        begin
            isBuffering := false;
            //restore original standard output
            Output := originalStdOutput;
            stream.position := 0;
            closeFile(streamStdOutput);
        end;
        result := self;
    end;

    {------------------------------------------------
     read output buffer content
    -----------------------------------------------}
    function TOutputBuffer.read() : string;
    begin
        result := stream.dataString;
    end;

    {------------------------------------------------
     read output buffer content and empty the buffer
    -----------------------------------------------}
    function TOutputBuffer.flush() : string;
    begin
        result := stream.dataString;
        stream.size := 0;
    end;

    {------------------------------------------------
     read content length
    -----------------------------------------------}
    function TOutputBuffer.size() : int64;
    begin
        result := stream.size;
    end;
end.
