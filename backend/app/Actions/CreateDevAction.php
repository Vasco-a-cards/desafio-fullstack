<?php

namespace App\Actions;

use App\Models\Dev;
use Illuminate\Support\Facades\DB;

class CreateDevAction
{
    /** @param array<string, mixed> $data */
    public function execute(array $data): Dev
    {
        return DB::transaction(fn () => Dev::create($data));
    }
}
