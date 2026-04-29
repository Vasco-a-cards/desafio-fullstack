<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement(<<<'SQL'
        CREATE OR REPLACE FUNCTION immutable_array_to_string(text[])
            RETURNS text
            LANGUAGE SQL
            IMMUTABLE
            PARALLEL SAFE
            AS $$ SELECT array_to_string($1, ' '); $$
        SQL);

        DB::statement('CREATE INDEX devs_nickname_trgm_idx ON devs USING gin (nickname gin_trgm_ops)');
        DB::statement('CREATE INDEX devs_name_trgm_idx ON devs USING gin (name gin_trgm_ops)');
        DB::statement('CREATE INDEX devs_stack_trgm_idx ON devs USING gin (immutable_array_to_string(stack) gin_trgm_ops)');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS devs_stack_trgm_idx');
        DB::statement('DROP INDEX IF EXISTS devs_name_trgm_idx');
        DB::statement('DROP INDEX IF EXISTS devs_nickname_trgm_idx');
        DB::statement('DROP FUNCTION IF EXISTS immutable_array_to_string(text[])');
    }
};
