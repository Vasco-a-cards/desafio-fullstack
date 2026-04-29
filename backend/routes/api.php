<?php

use App\Http\Controllers\Api\DevController;
use Illuminate\Support\Facades\Route;

Route::apiResource('devs', DevController::class)
    ->only(['index', 'store', 'show'])
    ->parameters(['devs' => 'dev'])
    ->where(['dev' => '[0-9a-f-]{36}']);
