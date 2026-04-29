<?php

namespace App\Http\Controllers\Api;

use App\Actions\CreateDevAction;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreDevRequest;
use App\Http\Resources\DevResource;
use App\Models\Dev;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DevController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        if ($request->has('terms') && trim((string) $request->query('terms')) === '') {
            return response()->json(['message' => 'The terms parameter cannot be empty.'], 400);
        }

        $total = Dev::count();

        $query = Dev::query();

        if ($request->filled('terms')) {
            $like = '%' . $request->query('terms') . '%';
            $query->where(function ($q) use ($like) {
                $q->whereRaw("unaccent(nickname) ILIKE unaccent(?)", [$like])
                  ->orWhereRaw("unaccent(name) ILIKE unaccent(?)", [$like])
                  ->orWhereRaw("unaccent(immutable_array_to_string(stack)) ILIKE unaccent(?)", [$like]);
            });
        }

        $devs = $query->limit(20)->get();

        return DevResource::collection($devs)
            ->response()
            ->header('X-Total-Count', $total);
    }

    public function store(StoreDevRequest $request, CreateDevAction $action): JsonResponse
    {
        $dev = $action->execute($request->validated());

        return (new DevResource($dev))
            ->response()
            ->setStatusCode(201)
            ->header('Location', "/devs/{$dev->id}");
    }

    public function show(Dev $dev): JsonResponse
    {
        return (new DevResource($dev))->response();
    }
}
