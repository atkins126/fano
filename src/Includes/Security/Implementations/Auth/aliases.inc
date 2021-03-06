{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in auth
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TCredential = CredentialTypes.TCredential;
TCredentials = CredentialTypes.TCredentials;

TStaticCredentialsAuth = StaticCredentialsAuthImpl.TStaticCredentialsAuth;
TBasicAuthMiddleware = BasicAuthMiddlewareImpl.TBasicAuthMiddleware;
TStaticCredentialsBasicAuthMiddlewareFactory = StaticCredentialsBasicAuthMiddlewareFactoryImpl.TStaticCredentialsBasicAuthMiddlewareFactory;

TDigestStaticCredentialsAuth = DigestStaticCredentialsAuthImpl.TDigestStaticCredentialsAuth;
TDigestAuthMiddleware = DigestAuthMiddlewareImpl.TDigestAuthMiddleware;
TStaticCredentialsDigestAuthMiddlewareFactory = StaticCredentialsDigestAuthMiddlewareFactoryImpl.TStaticCredentialsDigestAuthMiddlewareFactory;
