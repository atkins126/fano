{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ModelWriterIntf;

interface

{$MODE OBJFPC}

uses

    ModelDataIntf;

type

    (*!------------------------------------------------
     * interface for model that can write data to storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IModelWriter = interface
        ['{B12E2CDF-EA14-4DAC-83E9-ABB5919AA7D1}']

        (*!----------------------------------------------
         * write data to storage
         *-----------------------------------------------
         * @param params parameters related to data being stored
         * @param data data being stored
         * @return current instance
         *-----------------------------------------------*)
        function write(const params : IModelData; const data : IModelData) : IModel;
    end;

implementation

end.