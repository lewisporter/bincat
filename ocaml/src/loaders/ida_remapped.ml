(*
    This file is part of BinCAT.
    Copyright 2014-2017 - Airbus Group

    BinCAT is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or (at your
    option) any later version.

    BinCAT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with BinCAT.  If not, see <http://www.gnu.org/licenses/>.
*)

(* loader for IDA remapped binaries *)

module L = Log.Make(struct let name = "ida_remapped" end)

open Mapped_mem


let section_from_config_entry config_section_entry =
  match config_section_entry 
  with (lvirt_addr, lvirt_size, lraw_addr, lraw_size, lname) ->
    {
      virt_addr = Data.Address.global_of_int lvirt_addr ;
      virt_addr_end = Data.Address.global_of_int (Z.add lvirt_addr lvirt_size) ;
      virt_size = lvirt_size;
      raw_addr = lraw_addr;
      raw_addr_end = Z.add lraw_addr lraw_size;
      raw_size = lraw_size;
      name = lname;
    }

let make_mapped_mem () =
  let sections = List.map section_from_config_entry !Config.sections in
  let entrypoint = Data.Address.global_of_int !Config.ep in
  let mapped_file = map_file !Config.binary in
  {
    mapped_file = mapped_file ;
    sections  = sections ;
    entrypoint = entrypoint ;
  }
