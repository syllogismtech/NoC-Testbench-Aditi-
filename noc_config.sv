class noc_config extends uvm_object;
  `uvm_object_utils(noc_config)

  int num_masters;
  int num_slaves;

  axi_agent_config master_cfg[];
  axi_agent_config slave_cfg[];

  function new(string name = "noc_config");
    super.new(name);
  endfunction
endclass
