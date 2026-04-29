<?php

namespace Database\Seeders;

use App\Models\Dev;
use Illuminate\Database\Seeder;

class DevSeeder extends Seeder
{
    public function run(): void
    {
        $devs = [
            ['nickname' => 'judit',   'name' => 'Judit Polgár',     'birth_date' => '1976-07-23', 'stack' => ['C#', 'Node', 'Oracle']],
            ['nickname' => 'leo',     'name' => 'Leonardo Barreto', 'birth_date' => '1986-09-05', 'stack' => null],
            ['nickname' => 'ana',     'name' => 'Ana Barbosa',      'birth_date' => '1985-09-23', 'stack' => ['Node', 'Postgres']],
            ['nickname' => 'tomas',   'name' => 'Tomás Ferreira',   'birth_date' => '1988-11-20', 'stack' => ['Python', 'Django', 'Postgres']],
            ['nickname' => 'marina',  'name' => 'Marina Costa',     'birth_date' => '1993-07-04', 'stack' => ['Flutter', 'Dart', 'Laravel']],
        ];

        foreach ($devs as $data) {
            Dev::create($data);
        }
    }
}
