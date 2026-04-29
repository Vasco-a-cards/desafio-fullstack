<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;

class StoreDevRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        return [
            'nickname' => ['required', 'string', 'max:32', 'unique:devs,nickname'],
            'name' => ['required', 'string', 'max:100'],
            'birth_date' => ['required', 'date_format:Y-m-d'],
            'stack' => ['nullable', 'array'],
            'stack.*' => ['required', 'string', 'max:32'],
        ];
    }

    protected function prepareForValidation(): void
    {
        // Detect malformed JSON body before anything else
        $content = $this->getContent();
        if ($this->isJson() && $content !== '') {
            try {
                json_decode($content, true, 512, JSON_THROW_ON_ERROR);
            } catch (\JsonException) {
                throw new BadRequestHttpException('Invalid JSON');
            }
        }

        // Type checks — wrong PHP type (int, bool, object) → 400
        // null is allowed here; semantic nullability is enforced by validation rules → 422
        foreach (['nickname', 'name', 'birth_date'] as $field) {
            $value = $this->input($field);
            if ($this->has($field) && $value !== null && ! is_string($value)) {
                throw new BadRequestHttpException(
                    "Field [{$field}] must be a string."
                );
            }
        }

        $stack = $this->input('stack');
        if ($this->has('stack') && $stack !== null) {
            if (! is_array($stack)) {
                throw new BadRequestHttpException('Field [stack] must be an array or null.');
            }
            foreach ($stack as $i => $element) {
                if (! is_string($element)) {
                    throw new BadRequestHttpException("Field [stack.{$i}] must be a string.");
                }
            }
        }
    }
}
