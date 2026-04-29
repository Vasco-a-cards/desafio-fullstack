<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('devs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('nickname', 32)->unique();
            $table->string('name', 100);
            $table->date('birth_date');
            $table->timestamps();
        });

        DB::statement('ALTER TABLE devs ADD COLUMN stack text[]');
    }

    public function down(): void
    {
        Schema::dropIfExists('devs');
    }
};
