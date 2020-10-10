<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Jobs\SampleJobA;
use App\Jobs\SampleJobB;
use App\Jobs\SampleJobC;

class JobController extends Controller
{
    public function index()
    {
        SampleJobA::dispatch('jobA')->onQueue('sample_queA')->delay(now());
        SampleJobB::dispatch('jobB')->onQueue('sample_queB')->delay(now());
        SampleJobC::dispatch('jobC')->onQueue('sample_queC')->delay(now());
        return;
    }
}
