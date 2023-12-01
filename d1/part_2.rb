#!/usr/bin/env ruby
require 'logger'

class CalibrationValue
  WORD_DIGITS = %w[one two three four five six seven eight nine]
  DIGITS = %w[1 2 3 4 5 6 7 8 9]
  ALL = WORD_DIGITS + DIGITS

  attr_accessor :input

  def initialize(input)
    @input = input.chomp
  end

  def to_i
    [left_most_value, right_most_value].join.to_i.tap do |i|
      puts "Got #{i} from #{input.inspect}"
    end
  end

  def normalize_value(value)
    ((WORD_DIGITS.index(value) || DIGITS.index(value)) + 1).to_s
  end

  def left_most_value
    normalize_value(
      ALL
        .map { |v| [input.index(v), v] }
        .reject { |t| t.first.nil? }
        .sort { |a, b| a <=> b }
        .first
        .last
    )
  end

  def right_most_value
    normalize_value(
      ALL
        .map { |v| [input.rindex(v), v] }
        .reject { |t| t.first.nil? }
        .sort { |a, b| b <=> a }
        .first
        .last
    )
  end
end

class CalibrationValueExtractor
  DEBUG = true
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
      CalibrationValue.new(line).to_i
    end.tap do |cv|
      debug "Extracted '#{cv.count}' calibration values, sample: '#{cv.inspect}'"
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
end

sum = CalibrationValueExtractor.new.sum
puts "Found calibration value sum: #{sum}"
