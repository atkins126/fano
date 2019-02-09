{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpMethodImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libcurl,
    InjectableObjectImpl,
    HttpClientIntf,
    ResponseIntf,
    SerializeableIntf,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * base class for HTTP operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpMethod = class(TInjectableObject, IHttpClient)
    private

        (*!------------------------------------------------
         * raise exception if curl operation fail
         *-----------------------------------------------
         * @param errCode curl error code
         *-----------------------------------------------*)
        procedure raiseExceptionIfError(const errCode : CurlCode);

        (*!------------------------------------------------
         * intialize cURL
         *-----------------------------------------------
         * @return curl handle
         *-----------------------------------------------*)
        function initCurl() : pCurl;
    protected
        (*!------------------------------------------------
         * internal variable that holds curl handle
         *-----------------------------------------------*)
        hCurl : pCurl;

        (*!------------------------------------------------
         * internal variable that holds stream of data coming
         * from server
         *-----------------------------------------------*)
        pStream : pointer;

        (*!------------------------------------------------
         * raise exception if curl not initialized
         *-----------------------------------------------*)
        procedure raiseExceptionIfCurlNotInitialized();

        (*!------------------------------------------------
         * execute curl operation and raise exception if fail
         *-----------------------------------------------
         * @param hCurl curl handle
         * @return errCode curl error code
         *-----------------------------------------------*)
        function executeCurl(const hCurl : pCurl) : CurlCode;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param fStream stream instance that will be used to
         *                store data coming from server
         *-----------------------------------------------*)
        constructor create(const fStream : IStreamAdapter);

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * send HTTP request
         *-----------------------------------------------
         * @param url url to send request
         * @param data data related to this request
         * @return current instance
         *-----------------------------------------------*)
        function send(
            const url : string;
            const data : ISerializeable = nil
        ) : IResponse; virtual; abstract;

    end;

implementation

uses

    EHttpClientErrorImpl;

resourcestring

    sErrCurlNotInitialized = 'cURL not initialized.';

    (*!------------------------------------------------
     * internal callback that is called when libcurl needs to
     * write data coming from server
     *-----------------------------------------------
     * @param dataFromServer pointer to data from server
     * @param size Size in bytes of each element to be written
     * @param nmemb number of data items
     * @param ptrStream pointer to stream passed in CURLOPT_WRITEDATA
     * @return number of bytes actually process
     *------------------------------------------------
     * @link: https://ec.haxx.se/callback-write.html
     *-----------------------------------------------*)
    function writeToStream(
        dataFromServer : pointer;
        size : size_t;
        nmemb: size_t;
        ptrStream : pointer
    ) : size_t; cdecl;
    begin
        result := IStreamAdapter(ptrStream).write(ptr^, size * nmemb);
    end;

    (*!------------------------------------------------
     * intialize cURL
     *-----------------------------------------------
     * @return curl handle
     *-----------------------------------------------*)
    function THttpMethod.initCurl() : pCurl;
    begin
        //initialize curl
        result := curl_easy_init();
        curl_easy_setopt(result, CURLOPT_WRITEFUNCTION, [ @writeToStream ]);
        curl_easy_setopt(result , CURLOPT_WRITEDATA, [ pStream ]);
    end;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param fStream stream instance that will be used to
     *                store data coming from server
     *-----------------------------------------------*)
    constructor THttpMethod.create(const fStream : IStreamAdapter);
    begin
        //libcurl only knows raw pointer, so we use raw pointer to hold
        //instance of IStreamAdapter interface. But because typecast interface
        //to pointer does not do automatic reference counting,
        //we must add reference count manually by calling _AddRef() method
        pStream := pointer(fStream);
        fStream._addRef();

        hCurl := initCurl();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor THttpMethod.destroy();
    begin
        inherited destroy();

        //libcurl only knows raw pointer, so we use raw pointer to hold
        //instance of IStreamAdapter interface. But because typecast interface
        //to pointer does not do automatic reference counting,
        //we must decrement reference count manually by calling _Release() method
        IStreamAdapter(pStream)._release();
        pStream := nil;

        curl_easy_cleanup(hCurl);
    end;

    (*!------------------------------------------------
     * raise exception if curl not initialized
     *-----------------------------------------------*)
    procedure THttpMethod.raiseExceptionIfCurlNotInitialized();
    begin
        if (not assigned(hCurl)) then
        begin
            raise EHttpClientError.create(sErrCurlNotInitialized);
        end;
    end;

    (*!------------------------------------------------
     * raise exception if curl operation fail
     *-----------------------------------------------
     * @param errCode curl error code
     *-----------------------------------------------*)
    procedure THttpMethod.raiseExceptionIfError(const errCode : CurlCode);
    var errMsg : string;
    begin
        if (errCode <> CURLE_OK) then
        begin
            //operation fail, raise exception
            errMsg := curl_easy_strerror(errCode);
            raise EHttpClientErrorImpl.create(errMsg);
        end;
    end;

    (*!------------------------------------------------
     * execute curl operation and raise exception if fail
     *--------------------------------------------------
     * @param hCurl curl handle
     * @return errCode curl error code
     *---------------------------------------------------*)
    function THttpMethod.executeCurl(const hCurl : pCurl) : CurlCode;
    begin
        result := curl_easy_perform(hCurl);
        raiseExceptionIfError(result);
    end;

initialization
    curl_global_init(CURL_GLOBAL_DEFAULT);
finalization
    curl_global_cleanup();
end.