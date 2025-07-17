class noc_env extends uvm_env;
  `uvm_component_utils(tnoc_env)

  axi_agent master_agents[];
  axi_agent slave_agents[];

  noc_config cfg;
  noc_scoreboard sb;
  noc_virtual_sequencer vseqr;

  function new(string name = "noc_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(noc_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("CFG", "Config object not found")

    master_agents = new[cfg.num_masters];
    foreach (master_agents[i]) begin
      uvm_config_db#(axi_agent_config)::set(this, $sformatf("master_agents[%0d]", i), "cfg", cfg.master_cfg[i]);
      master_agents[i] = axi_agent::type_id::create($sformatf("master_agents[%0d]", i), this);
    end

    slave_agents = new[cfg.num_slaves];
    foreach (slave_agents[i]) begin
      uvm_config_db#(axi_agent_config)::set(this, $sformatf("slave_agents[%0d]", i), "cfg", cfg.slave_cfg[i]);
      slave_agents[i] = axi_agent::type_id::create($sformatf("slave_agents[%0d]", i), this);
    end

    sb = noc_scoreboard::type_id::create("sb", this);

    vseqr = noc_virtual_sequencer::type_id::create("vseqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    foreach (master_agents[i]) begin
      vseqr.master_seqrs.push_back(master_agents[i].m_seqr); // pushing master agents to virtual sequencer so that vseqr can control all of the masters 
    end
    foreach (slave_agents[i]) begin
      vseqr.slave_seqrs.push_back(slave_agents[i].m_seqr); // // pushing slave agents to virtual sequencer so that vseqr can control all of the slaves  
    end

    // Connect monitors to scoreboard
    foreach (master_agents[i]) begin
      master_agents[i].mon.monitor_ap.connect(sb.master_analysis_export[i]);
    end
    foreach (slave_agents[i]) begin
      slave_agents[i].mon.monitor_ap.connect(sb.slave_analysis_export[i]);
    end
  endfunction

endclass
