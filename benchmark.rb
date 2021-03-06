#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'timezone'

def load_tz(timezone)
  Timezone.fetch(timezone)
end

puts 'Loading timezones'

LOAD_ITERATIONS = 1_000
Benchmark.bm do |x|
  x.report('la') { LOAD_ITERATIONS.times { load_tz('America/Los_Angeles') } }
  x.report('hk') { LOAD_ITERATIONS.times { load_tz('Asia/Hong_Kong') } }
end

def calc_local(timezone)
  timezone.time(Time.utc(3000, 1, 1))
end

puts 'Calculating LOCAL'

LOCAL_ITERATIONS = 10_000
Benchmark.bm do |x|
  timezone = Timezone.fetch('America/Los_Angeles')
  x.report('la') { LOCAL_ITERATIONS.times { calc_local(timezone) } }
  timezone = Timezone.fetch('Asia/Hong_Kong')
  x.report('hk') { LOCAL_ITERATIONS.times { calc_local(timezone) } }
end

def calc_utc(timezone)
  timezone.local_to_utc(Time.utc(3000, 1, 1))
end

puts 'Calculating UTC'

UTC_ITERATIONS = 10_000
Benchmark.bm do |x|
  timezone = Timezone.fetch('America/Los_Angeles')
  x.report('la') { UTC_ITERATIONS.times { calc_utc(timezone) } }
  timezone = Timezone.fetch('Asia/Hong_Kong')
  x.report('hk') { UTC_ITERATIONS.times { calc_utc(timezone) } }
end
