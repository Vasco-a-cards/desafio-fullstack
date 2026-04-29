<?php

namespace App\Casts;

use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
use Illuminate\Database\Eloquent\Model;
use InvalidArgumentException;

class PostgresArray implements CastsAttributes
{
    /**
     * PHP array → Postgres text[] literal: {"item1","item2"}
     */
    public function set(Model $model, string $key, mixed $value, array $attributes): ?string
    {
        if ($value === null) {
            return null;
        }

        if (! is_array($value)) {
            throw new InvalidArgumentException("Value for [{$key}] must be an array or null.");
        }

        if (empty($value)) {
            return '{}';
        }

        $escaped = array_map(function (string $item): string {
            $item = str_replace('\\', '\\\\', $item); // backslash first
            $item = str_replace('"', '\\"', $item);   // then double-quote
            return '"' . $item . '"';
        }, $value);

        return '{' . implode(',', $escaped) . '}';
    }

    /**
     * Postgres text[] literal → PHP array
     * Handles both quoted {"a","b"} and unquoted {a,b} elements,
     * plus escaped chars inside quoted elements.
     */
    public function get(Model $model, string $key, mixed $value, array $attributes): ?array
    {
        if ($value === null) {
            return null;
        }

        $value = trim($value);

        if ($value === '{}') {
            return [];
        }

        $inner = substr($value, 1, -1); // strip outer { }
        $result = [];
        $i = 0;
        $len = strlen($inner);

        while ($i < $len) {
            if ($inner[$i] === '"') {
                // Quoted element — respect \" and \\ escaping
                $i++;
                $element = '';
                while ($i < $len) {
                    if ($inner[$i] === '\\') {
                        $i++;
                        $element .= $inner[$i];
                    } elseif ($inner[$i] === '"') {
                        $i++;
                        break;
                    } else {
                        $element .= $inner[$i];
                    }
                    $i++;
                }
                $result[] = $element;
                if ($i < $len && $inner[$i] === ',') {
                    $i++;
                }
            } else {
                // Unquoted element — simple string with no special chars
                $end = strpos($inner, ',', $i);
                if ($end === false) {
                    $result[] = substr($inner, $i);
                    break;
                }
                $result[] = substr($inner, $i, $end - $i);
                $i = $end + 1;
            }
        }

        return $result;
    }
}
