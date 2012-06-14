require 'logger'

# init
logger = Logger.new(STDOUT)

# welcome
logger.info "--------------------------------------------------------------"
logger.info "Welcome!"
logger.info "You're using now Time Comparision Tool, developed by AIFB, KIT"
logger.info "Trace the logger to get the information you want to know!"
logger.info "--------------------------------------------------------------"

if ENV['WHIRR_HOME'].nil?
	logger.info "Please set an system variable named WHIRR_HOME in your Linux environment"
	logger.info "WHIRR_HOME muss point to the top level folder of Whirr"
	exit 1
else
	whirr = ENV['WHIRR_HOME']
end

logger.info "-----------------------------------------------------------------------------------------"
logger.info "Input the absolute folder path for your CONFIGURATION FILES (e.g. /home/markus/configdir)"

# get input from user
config_dir = gets  
config_dir = config_dir.chomp # delete the last enter character

Dir.chdir(config_dir)
config_files = Dir.glob('*.properties')

logger.info "You have #{config_files.size} configuration files (ending .properties) in the #{config_dir}:"
config_files.each {|config_file| logger.info "-- #{config_file}"}
logger.info "-----------------------------------------------------------------------------------------"

logger.info "---------------------------------------------------"
logger.info "Log file is #{ENV['HOME']}/time_comparision_log.txt"
File.open("#{ENV['HOME']}/time_comparision_log.txt","w") {}
logger.info "---------------------------------------------------"

mode = "dumy"
until ["B","I","Q"].include? mode
  logger.info "-------------------------------------------------------"
  logger.info "So," 
  logger.info "press (B) for Batch Mode"
  logger.info "press (I) for Incremental Mode"
  logger.info "press (Q) to quit"
  logger.info "-------------------------------------------------------"
  
  # get input from user
  mode = gets  
  mode = mode.chomp # delete the last enter character
end

if mode == "B"
  logger.info "-----------------------------------------------"
  logger.info "You've chosen Batch Mode"
	logger.info "All configuration files will be used ONE BY ONE"  
	logger.info "-----------------------------------------------"

	log_file = File.open("#{ENV['HOME']}/time_comparision_log.txt","a")

	config_files.each do |config_file|
		logger.info "------------------"
		logger.info "USE: #{config_file}"		
		logger.info "------------------"
		
		log_file << "BATCH MODE - USE CONFIG FILE: #{config_file}"

		beginning = Time.now
		log_file << "BATCH MODE - BEGINNING - #{beginning}"

		logger.info "Now: #{beginning}"
		config_file_path = config_dir << "/" << config_file

		logger.info "----------------------------"
		logger.info "Step 1: LAUNCHING cluster..."		
		logger.info "----------------------------"
		system "#{whirr}/bin/whirr launch-cluster --config=#{config_file_path}"
		log_file << "BATCH MODE - LAUNCH - #{Time.now}"
		log_file << "BATCH MODE - Until now, time elapsed: #{Time.now - beginning} seconds"		
		logger.info "::: Until now, time elapsed: #{Time.now - beginning} seconds"		
		
		logger.info "----------------------------------------------"
		logger.info "Step 2.1.: Running experiment, action: LOAD..."		
		logger.info "----------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=load"
		log_file << "BATCH MODE - LOAD - #{Time.now}"
		log_file << "BATCH MODE - Until now, time elapsed: #{Time.now - beginning} seconds"
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "---------------------------------------------"
		logger.info "Step 2.2.: Running experiment, action: RUN..."		
		logger.info "---------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=run"
		log_file << "BATCH MODE - RUN - #{Time.now}"
		log_file << "BATCH MODE - Until now, time elapsed: #{Time.now - beginning} seconds"
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "------------------------------------------------"
		logger.info "Step 2.3.: Running experiment, action: UPLOAD..."		
		logger.info "------------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=upload"
		log_file << "BATCH MODE - UPLOAD - #{Time.now}"
		log_file << "BATCH MODE - Until now, time elapsed: #{Time.now - beginning} seconds"		
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "-----------------------------"
		logger.info "Step 3: DESTROYING cluster..."		
		logger.info "-----------------------------"
		system "#{whirr}/bin/whirr destroy-cluster --config=#{config_file_path}"
		log_file << "BATCH MODE - DESTROY - #{Time.now}"
		log_file << "BATCH MODE - Until now, time elapsed: #{Time.now - beginning} seconds"		
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"

		log_file.close	
	end
  
elsif mode == "I"
	logger.info "--------------------------------------------------------------------------------------------------------"
  logger.info "You've chosen Incremental Mode"
	logger.info "The FIRST properties file is used to LAUNCH the cluster"
	logger.info "The OTHER properties files are used to REPAIR the cluster"
	logger.info "Make sure that your properties file NAMES are INCREMENTAL, e.g. ycsb1.properites, ycsb2.properites, etc." 
	logger.info "--------------------------------------------------------------------------------------------------------"
  
	log_file = File.open("#{ENV['HOME']}/time_comparision_log.txt","a")

	logger.info "-------------------------"
	logger.info "Get the first config file"
	logger.info "-------------------------"
	first_config_file = config_files.shift
	logger.info "-----------------------------------------------------------------------"
	logger.info "FIRST CONFIG FILE: #{first_config_file}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - USE CONFIG FILE: #{first_config_file}"	
	logger.info "-----------------------------------------------------------------------"

	logger.info "-----------------------------------------------"
	logger.info "Step 1: Run the FIRST config file in BATCH mode"
	logger.info "-----------------------------------------------"
	beginning = Time.now
	log_file << "INCREMENTAL MODE - FIRST CONFIG - BEGINNING - #{beginning}"	
	logger.info "Now: #{beginning}"
	first_config_file_path = config_dir << "/" << first_config_file

	logger.info "-------------------------------"
	logger.info "Step 1.1.: LAUNCHING cluster..."		
	logger.info "-------------------------------"
	system "#{whirr}/bin/whirr launch-cluster --config=#{first_config_file_path}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - LAUNCH - #{Time.now}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - Until now, time elapsed: #{Time.now - beginning} seconds"
	logger.info "::: Until now, time elapsed: #{Time.now - beginning} seconds"		
		
	logger.info "----------------------------------------------"
	logger.info "Step 1.2.: Running experiment, action: LOAD..."		
	logger.info "----------------------------------------------"
	system "#{whirr}/bin/whirr run-experiment --config=#{first_config_file_path} --ycsb-experiment-action=load"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - LOAD - #{Time.now}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - Until now, time elapsed: #{Time.now - beginning} seconds"
	logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

	logger.info "---------------------------------------------"
	logger.info "Step 1.3.: Running experiment, action: RUN..."		
	logger.info "---------------------------------------------"
	system "#{whirr}/bin/whirr run-experiment --config=#{first_config_file_path} --ycsb-experiment-action=run"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - RUN - #{Time.now}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - Until now, time elapsed: #{Time.now - beginning} seconds"	
	logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

	logger.info "------------------------------------------------"
	logger.info "Step 1.4.: Running experiment, action: UPLOAD..."		
	logger.info "------------------------------------------------"
	system "#{whirr}/bin/whirr run-experiment --config=#{first_config_file_path} --ycsb-experiment-action=upload"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - UPLOAD - #{Time.now}"
	log_file << "INCREMENTAL MODE - FIRST CONFIG - Until now, time elapsed: #{Time.now - beginning} seconds"	
	logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

	logger.info "-------------------------------------------------------------------------------------------------"
	logger.info "Step 2: Start a LOOP over the OTHER config files and run repair-cluster instead of launch-cluster"
	logger.info "-------------------------------------------------------------------------------------------------"
	config_files.each do |config_file|
		logger.info "-------------------"
		logger.info "USE: #{config_file}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - USE CONFIG FILE: #{config_file}"
		logger.info "-------------------"
		
		beginning = Time.now
		logger.info "Now: #{beginning}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - BEGINNING: #{beginning}"
		config_file_path = config_dir << "/" << config_file

		logger.info "-------------------------------"
		logger.info "Step 2.1.: REPAIRING cluster..."		
		logger.info "-------------------------------"
		system "#{whirr}/bin/whirr repair-cluster --config=#{config_file_path}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - REPAIR - #{Time.now}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - Until now, time elapsed: #{Time.now - beginning} seconds"
		logger.info "::: Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "----------------------------------------------"
		logger.info "Step 2.2.: Running experiment, action: LOAD..."		
		logger.info "----------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=load"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - LOAD - #{Time.now}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - Until now, time elapsed: #{Time.now - beginning} seconds"
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "---------------------------------------------"
		logger.info "Step 2.3.: Running experiment, action: RUN..."		
		logger.info "---------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=run"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - RUN - #{Time.now}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - Until now, time elapsed: #{Time.now - beginning} seconds"		
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	

		logger.info "------------------------------------------------"
		logger.info "Step 2.4.: Running experiment, action: UPLOAD..."		
		logger.info "------------------------------------------------"
		system "#{whirr}/bin/whirr run-experiment --config=#{config_file_path} --ycsb-experiment-action=upload"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - UPLOAD - #{Time.now}"
		log_file << "INCREMENTAL MODE - OTHER CONFIGS - Until now, time elapsed: #{Time.now - beginning} seconds"		
		logger.info "Until now, time elapsed: #{Time.now - beginning} seconds"	
	end
	
	logger.info "---------------------------"
	logger.info "Step 3: DESTROY the cluster"
	logger.info "---------------------------"

	last_config_file = config_files.pop
	last_config_file_path = config_dir << "/" << last_config_file

	logger.info "---------------------"
	logger.info "DESTROYING cluster..."		
	logger.info "---------------------"
	
	system "#{whirr}/bin/whirr destroy-cluster --config=#{last_config_file_path}"
	log_file << "INCREMENTAL MODE - OTHER CONFIGS - DESTROY - #{Time.now}"
	log_file << "INCREMENTAL MODE - OTHER CONFIGS - Until now, time elapsed: #{Time.now - beginning} seconds"	
	logger.info "::: Until now, time elapsed: #{Time.now - beginning} seconds"	

	log_file.close
elsif mode == "Q"
  logger.info "---------------------"
  logger.info "OK, you want to quit!"
  logger.info "---------------------"
  exit 1
end
