{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.home.utilities;
in
{
  options.modules.home.utilities.enable = lib.mkEnableOption "home utilities";

  config = lib.mkIf cfg.enable {
    catppuccin = {
      eza = {
        enable = true;
        flavor = "mocha";
      };
      btop = {
        enable = true;
        flavor = "mocha";
      };
      fastfetch = {
        enable = true;
        flavor = "mocha";
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        theme_background = true;
        truecolor = true;
        force_tty = false;
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = false;
        rounded_corners = true;
        terminal_sync = true;
        graph_symbol = "braille";
        graph_symbol_cpu = "default";
        graph_symbol_gpu = "default";
        graph_symbol_mem = "default";
        graph_symbol_net = "default";
        graph_symbol_proc = "default";
        shown_boxes = "cpu mem net proc";
        update_ms = 2000;
        proc_sorting = "cpu lazy";
        proc_reversed = false;
        proc_tree = false;
        proc_colors = true;
        proc_gradient = true;
        proc_per_core = false;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        proc_info_smaps = false;
        proc_left = false;
        proc_filter_kernel = false;
        proc_aggregate = false;
        keep_dead_proc_usage = false;
        cpu_graph_upper = "Auto";
        cpu_graph_lower = "Auto";
        show_gpu_info = "Auto";
        cpu_invert_lower = true;
        cpu_single_graph = false;
        cpu_bottom = false;
        show_uptime = true;
        show_cpu_watts = true;
        check_temp = true;
        cpu_sensor = "Auto";
        show_coretemp = true;
        cpu_core_map = "";
        temp_scale = "celsius";
        base_10_sizes = false;
        show_cpu_freq = true;
        freq_mode = "first";
        clock_format = "%X";
        background_update = true;
        custom_cpu_name = "";
        disks_filter = "";
        mem_graphs = true;
        mem_below_net = false;
        zfs_arc_cached = true;
        show_swap = true;
        swap_disk = true;
        show_disks = true;
        only_physical = true;
        use_fstab = true;
        zfs_hide_datasets = false;
        disk_free_priv = false;
        show_io_stat = true;
        io_mode = false;
        io_graph_combined = false;
        io_graph_speeds = "";
        net_download = 100;
        net_upload = 100;
        net_auto = true;
        net_sync = true;
        net_iface = "";
        base_10_bitrate = "Auto";
        show_battery = true;
        selected_battery = "Auto";
        show_battery_watts = true;
        log_level = "WARNING";
        save_config_on_exit = true;
        nvml_measure_pcie_speeds = true;
        rsmi_measure_pcie_speeds = true;
        gpu_mirror_graph = true;
        shown_gpus = "nvidia amd intel";
      };
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = {
          type = "builtin";
          source = "NixOS_small";
          padding = {
            top = 1;
            left = 2;
            right = 2;
          };
        };
        display = {
          separator = " ❯ ";
          color.keys = "magenta";
        };
        modules = [
          "break"
          {
            type = "title";
            key = "";
            format = "{user-name}@{host-name}";
          }
          {
            type = "separator";
            string = "──────────────────────";
          }
          {
            type = "os";
            key = "󱄅";
            format = "{3} {12}";
          }
          {
            type = "kernel";
            key = "";
          }
          {
            type = "shell";
            key = "";
          }
          {
            type = "wm";
            key = "";
          }
          {
            type = "terminal";
            key = "";
          }
          {
            type = "font";
            key = "󰛖";
          }
          {
            type = "separator";
            string = "──────────────────────";
          }
          {
            type = "cpu";
            key = "";
          }
          {
            type = "gpu";
            key = "󰍺";
          }
          {
            type = "memory";
            key = "󰍛";
          }
          {
            type = "disk";
            key = "󰋊";
            folders = "/";
          }
          {
            type = "display";
            key = "󰍹";
          }
          {
            type = "battery";
            key = "󰁹";
          }
          {
            type = "separator";
            string = "──────────────────────";
          }
          {
            type = "uptime";
            key = "󱎫";
          }
          {
            type = "packages";
            key = "󰏖";
          }
          "break"
          {
            type = "colors";
            symbol = "circle";
          }
        ];
      };
    };

  };
}
