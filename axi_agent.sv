class axi_agent extends uvm_agent;
  `uvm_component_utils(axi_agent)

  axi_sequencer    m_seqr;  
  axi_driver       m_drv;    
  axi_monitor      mon;      

  axi_agent_config cfg;      

  function new(string name = "axi_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Fetch and store config object for this agent
    if (!uvm_config_db#(axi_agent_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("AGENT_CFG", "Agent config not set!")

    mon = axi_monitor::type_id::create("mon", this);

    if (cfg.is_active) begin   // if agent is active, then make seqr and drvr
      m_seqr = axi_sequencer::type_id::create("m_seqr", this);
      m_drv  = axi_driver::type_id::create("m_drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if (cfg.is_active && m_drv != null && m_seqr != null)
      m_drv.seq_item_port.connect(m_seqr.seq_item_export);
  endfunction
endclass
