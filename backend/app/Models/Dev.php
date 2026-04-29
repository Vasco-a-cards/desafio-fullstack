<?php

namespace App\Models;

use App\Casts\PostgresArray;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/** @property list<string>|null $stack */
class Dev extends Model
{
    use HasUuids;

    protected $fillable = [
        'nickname',
        'name',
        'birth_date',
        'stack',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'birth_date' => 'date:Y-m-d',
        'stack' => PostgresArray::class,
    ];
}
