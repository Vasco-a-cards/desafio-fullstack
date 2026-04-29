<?php

namespace App\Http\Resources;

use App\Models\Dev;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin Dev */
class DevResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nickname' => $this->nickname,
            'name' => $this->name,
            'birth_date' => $this->birth_date->format('Y-m-d'),
            'stack' => $this->stack,
        ];
    }
}
