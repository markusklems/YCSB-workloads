require 'logger'

# init
logger = Logger.new(STDOUT)

# welcome
logger.info "--------------------------------------------------------------------"
logger.info "Welcome!"
logger.info "You're using now Workload Data Catcher Tool, developed by AIFB, KIT"
logger.info "Trace the logger to get the information you want to know!"
logger.info "--------------------------------------------------------------------"

logger.info "---------------------------------------------------------------------------------------------"
logger.info "Input the absolute folder path for your WORKLOAD DATA FILES (e.g. /home/markus/workload_data)"

# get input from user
workload_data_dir = gets  
workload_data_dir = workload_data_dir.chomp # delete the last enter character

Dir.chdir(workload_data_dir)
workload_data_files = Dir.glob('*')

logger.info "You have #{workload_data_files.size} workload data files in the #{workload_data_dir}:"
workload_data_files.each {|workload_data_file| logger.info "-- #{workload_data_file}"}
logger.info "-----------------------------------------------------------------------------------------"


logger.info "---------------------------------------------------"
logger.info "CSV file is #{ENV['HOME']}/workload_data.csv"
File.open("#{ENV['HOME']}/workload_data.csv","w") {}
csv = File.open("#{ENV['HOME']}/workload_data.csv","a")
logger.info "---------------------------------------------------"

logger.info "---------------------------------------------------"

workload_data_files.each do |file|

  # file name
  csv << file << ","
  
  # split via _
  tmp = file.to_s.chomp(".dat").to_s.split("_")
  
  tmp.each do |ele|
    if (ele != "test")
      csv << ele << ","
    end 
  end
  
  # read content
  file_path = workload_data_dir + "/" + file
  
  File.open(file_path,"r") do |file_content|

    hash = Hash.new
    hash['INSERT'] = []
    hash['UPDATE'] = []
    hash['READ'] = []

    file_content.each do |line|
    
      # average through put
      if line.to_s.include? "[OVERALL], Throughput(ops/sec)"
        csv << (line.to_s.split",")[2].chop!.to_s.strip << ","
      
      # INSERT
      elsif line.to_s.include? "[INSERT], Operations"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], AverageLatency"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], MinLatency"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], MaxLatency"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], 95thPercentileLatency"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], 99thPercentileLatency"
        hash['INSERT'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[INSERT], Return=0"
        hash['INSERT'] << (line.to_s.split",")[2].chop!

      # READ
      elsif line.to_s.include? "[READ], Operations"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], AverageLatency"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], MinLatency"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], MaxLatency"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], 95thPercentileLatency"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], 99thPercentileLatency"
        hash['READ'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[READ], Return=0"
        hash['READ'] << (line.to_s.split",")[2].chop!
      
      
      # UPDATE
      elsif line.to_s.include? "[UPDATE], Operations"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], AverageLatency"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], MinLatency"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], MaxLatency"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], 95thPercentileLatency"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], 99thPercentileLatency"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      elsif line.to_s.include? "[UPDATE], Return=0"
        hash['UPDATE'] << (line.to_s.split",")[2].chop!
      
      end

    end
    
    
    # debug
=begin
    puts file_path
    puts "INSERT"
    puts hash['INSERT']
    puts "READ"
    puts hash['READ']
    puts "UPDATE"
    puts hash['UPDATE']
=end    
    
    if hash['INSERT'].size > 1
      csv << "INSERT" << ","
      hash['INSERT'].each {|ele| csv << ele.to_s.strip << ","}
    end
      
    if hash['UPDATE'].size > 1
      csv << "UPDATE" << ","
      hash['UPDATE'].each {|ele| csv << ele.to_s.strip << ","}
    end
    
    if hash['READ'].size > 1
      csv << "READ" << ","
      hash['READ'].each {|ele| csv << ele.to_s.strip << ","}
    end
      
  end 
  
  csv << "\n"
  
end
logger.info "---------------------------------------------------"

=begin
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
=end