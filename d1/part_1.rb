#!/usr/bin/env ruby
require 'logger'

class CalibrationValueExtractor
  DEBUG = true
  DIGIT = /\d/
  INPUT = './input'

  attr_reader :lines, :logger
  def initialize
    @lines = File.readlines(INPUT)
    @logger = Logger.new(STDOUT).tap do |l|
      l.level = DEBUG ? Logger::DEBUG : Logger::WARN
    end
    debug "Read #{@lines.count} lines from #{INPUT}, sample: #{@lines.sample(3).inspect}"
  end

  def calibration_values
    @calibration_values ||= lines.map do |line|
      first_last_integer(remove_alphas(line))
    end.tap do |cv|
      debug "Extracted '#{cv.count}' calibration values, sample: '#{cv.sample(3).inspect}'"
    end
  end

  def sum
    @sum ||= calibration_values.reduce(&:+).tap do |s|
      debug "Calibration value sum: '#{s}'"
    end
  end

  private

  def debug(msg)
    logger.debug(msg)
  end

  def first_last_integer(line)
    [line.first, line.last].join.to_i
  end

  def remove_alphas(line)
    line.chars.keep_if { |c| c.between?('0', '9') }
  end
end

sum = CalibrationValueExtractor.new.sum
puts "Found calibration value sum: #{sum}"
