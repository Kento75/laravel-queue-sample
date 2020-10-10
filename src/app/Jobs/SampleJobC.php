<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class SampleJobC implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    private $jobType;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($jobType)
    {
        $this->jobType = $jobType;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        Log::info($this->jobType . "start");

        for ($i = 0; $i < 10; $i++) {
            Log::info("JobC:" . $i);
            sleep(1);
        }

        Log::info($this->jobType . "end");
    }
}
