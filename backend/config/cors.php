<?php

return [

    /*
     * Paths that CORS applies to. '*' covers all routes.
     */
    'paths' => ['*'],

    'allowed_methods' => ['*'],

    /*
     * In development, allow all origins.
     * For production, restrict to the actual frontend origin.
     */
    'allowed_origins' => ['*'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    /*
     * X-Total-Count must be exposed so the Flutter client can read it
     * from the response headers of the devs list endpoint.
     */
    'exposed_headers' => ['X-Total-Count', 'Location'],

    'max_age' => 7200,

    'supports_credentials' => false,

];
