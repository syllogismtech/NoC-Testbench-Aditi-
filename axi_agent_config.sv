class axi_agent_config extends uvm_object;
  `uvm_object_utils(axi_agent_config)

  string agent_name;
  int    agent_id;
  bit    is_active;      // 1 = active, 0 = passive 
  int    data_width;
  int    address_width;

  function new(string name = "axi_agent_config");
    super.new(name);
    is_active = 1;
  endfunction
endclass
