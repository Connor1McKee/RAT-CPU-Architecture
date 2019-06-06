-----------------------------------------------------------------------------
-- Definition of a single port ROM for RATASM defined by prog_rom.psm 
--  
-- Generated by RATASM Assembler 
--  
-- Standard IEEE libraries  
--  
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library unisim;
use unisim.vcomponents.all;
-----------------------------------------------------------------------------


entity prog_rom is 
   port (     ADDRESS : in std_logic_vector(9 downto 0); 
          INSTRUCTION : out std_logic_vector(17 downto 0); 
                  CLK : in std_logic);  
end prog_rom;



architecture low_level_definition of prog_rom is

   -----------------------------------------------------------------------------
   -- Attributes to define ROM contents during implementation synthesis. 
   -- The information is repeated in the generic map for functional simulation. 
   -----------------------------------------------------------------------------

   attribute INIT_00 : string; 
   attribute INIT_01 : string; 
   attribute INIT_02 : string; 
   attribute INIT_03 : string; 
   attribute INIT_04 : string; 
   attribute INIT_05 : string; 
   attribute INIT_06 : string; 
   attribute INIT_07 : string; 
   attribute INIT_08 : string; 
   attribute INIT_09 : string; 
   attribute INIT_0A : string; 
   attribute INIT_0B : string; 
   attribute INIT_0C : string; 
   attribute INIT_0D : string; 
   attribute INIT_0E : string; 
   attribute INIT_0F : string; 
   attribute INIT_10 : string; 
   attribute INIT_11 : string; 
   attribute INIT_12 : string; 
   attribute INIT_13 : string; 
   attribute INIT_14 : string; 
   attribute INIT_15 : string; 
   attribute INIT_16 : string; 
   attribute INIT_17 : string; 
   attribute INIT_18 : string; 
   attribute INIT_19 : string; 
   attribute INIT_1A : string; 
   attribute INIT_1B : string; 
   attribute INIT_1C : string; 
   attribute INIT_1D : string; 
   attribute INIT_1E : string; 
   attribute INIT_1F : string; 
   attribute INIT_20 : string; 
   attribute INIT_21 : string; 
   attribute INIT_22 : string; 
   attribute INIT_23 : string; 
   attribute INIT_24 : string; 
   attribute INIT_25 : string; 
   attribute INIT_26 : string; 
   attribute INIT_27 : string; 
   attribute INIT_28 : string; 
   attribute INIT_29 : string; 
   attribute INIT_2A : string; 
   attribute INIT_2B : string; 
   attribute INIT_2C : string; 
   attribute INIT_2D : string; 
   attribute INIT_2E : string; 
   attribute INIT_2F : string; 
   attribute INIT_30 : string; 
   attribute INIT_31 : string; 
   attribute INIT_32 : string; 
   attribute INIT_33 : string; 
   attribute INIT_34 : string; 
   attribute INIT_35 : string; 
   attribute INIT_36 : string; 
   attribute INIT_37 : string; 
   attribute INIT_38 : string; 
   attribute INIT_39 : string; 
   attribute INIT_3A : string; 
   attribute INIT_3B : string; 
   attribute INIT_3C : string; 
   attribute INIT_3D : string; 
   attribute INIT_3E : string; 
   attribute INIT_3F : string; 
   attribute INITP_00 : string; 
   attribute INITP_01 : string; 
   attribute INITP_02 : string; 
   attribute INITP_03 : string; 
   attribute INITP_04 : string; 
   attribute INITP_05 : string; 
   attribute INITP_06 : string; 
   attribute INITP_07 : string; 


   ----------------------------------------------------------------------
   -- Attributes to define ROM contents during implementation synthesis.
   ----------------------------------------------------------------------

   attribute INIT_00 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000008080";  
   attribute INIT_01 of ram_1024_x_18 : label is "66FF692D680567048B7966FF6936682D67048B7966FF6936680567048BA9A000";  
   attribute INIT_02 of ram_1024_x_18 : label is "670A8B796909683467048A2966FF682F67048D198B4966FF692D680567368B49";  
   attribute INIT_03 of ram_1024_x_18 : label is "89D1684367048A29683E67048A29683967048B796909683767048B4969366835";  
   attribute INIT_04 of ram_1024_x_18 : label is "670D8B49694B6849670A8BF9684967078B49694B684967048B79690968486705";  
   attribute INIT_05 of ram_1024_x_18 : label is "6913683C670E8B7969136839670E8B49693B683A670D89D16834670D8A29682F";  
   attribute INIT_06 of ram_1024_x_18 : label is "6940683F67108B79690F683E670E8B496941683F670D8B49693B683A67108B79";  
   attribute INIT_07 of ram_1024_x_18 : label is "8B4969466844670D8BF96843670E8B496940683E67138B796912684167118B49";  
   attribute INIT_08 of ram_1024_x_18 : label is "8B4966D0693868348B4966E06933682F67158B7969136845670D8BF96847670E";  
   attribute INIT_09 of ram_1024_x_18 : label is "8B496687694C68488B496603694768438B49661C6942683E8B4966D8693D6839";  
   attribute INIT_0A of ram_1024_x_18 : label is "6705681666D08BF9670A68138BF9670A68158BF9670968148BF96708681366D8";  
   attribute INIT_0B of ram_1024_x_18 : label is "8BF96705681B8BF96706681B8BF9670768148BF9670668148BF9670668158BF9";  
   attribute INIT_0C of ram_1024_x_18 : label is "8BF9670768118BF9670668128BF96705681266878BF96706681F8BF96705681E";  
   attribute INIT_0D of ram_1024_x_18 : label is "8BF96708681F8BF96707681E66038BF96707681A8BF9670668198BF967056818";  
   attribute INIT_0E of ram_1024_x_18 : label is "8BF9670968168BF9670868178BF967076818661C8BF9670A681D8BF96709681E";  
   attribute INIT_0F of ram_1024_x_18 : label is "6A00690068006700650064008BF9670A681B8BF96709681A8BF96708681966E0";  
   attribute INIT_10 of ram_1024_x_18 : label is "A910037EA8E00354A8B0032A8840A00088510000610060007F007E006C006B00";  
   attribute INIT_11 of ram_1024_x_18 : label is "673968196687718780028BF967396819661C711CA9A003FFA97003D2A94003A8";  
   attribute INIT_12 of ram_1024_x_18 : label is "66D071D080028BF96739681966E071E080028BF9673968196603710380028BF9";  
   attribute INIT_13 of ram_1024_x_18 : label is "880147598B794B398905493980028BF96739681966D871D880028BF967396819";  
   attribute INIT_14 of ram_1024_x_18 : label is "4C49890149418801496147598B794C494B398906493980028B49890249418706";  
   attribute INIT_15 of ram_1024_x_18 : label is "890149398802C705485149618B498703485149618B498703485149618B494A41";  
   attribute INIT_16 of ram_1024_x_18 : label is "890180028B53484888018BF9890180028B7989038703496147598B794C494B39";  
   attribute INIT_17 of ram_1024_x_18 : label is "443980028BBB0A3C8A018B49694F680047516A00660080028B83474887018BF9";  
   attribute INIT_18 of ram_1024_x_18 : label is "0401043F057F454144398C2825808002469244904591AC480401043F057F4541";  
   attribute INIT_19 of ram_1024_x_18 : label is "3F9344904591AD080401043F057F455944518C88258080023F9344904591ACA8";  
   attribute INIT_1A of ram_1024_x_18 : label is "681B67328BF9681767328B49691A681867318B796935681967308CE825808002";  
   attribute INIT_1B of ram_1024_x_18 : label is "681D67318BF9681C67328BF9681B67338BF9681A67348BF96819673580028BF9";  
   attribute INIT_1C of ram_1024_x_18 : label is "8BF9681867348BF96819673580028B796934681D67338B49691B681A67318BF9";  
   attribute INIT_1D of ram_1024_x_18 : label is "6934681567338B496918681767318BF9681567318BF9681667328BF968176733";  
   attribute INIT_1E of ram_1024_x_18 : label is "66FF8D19660060FF88388FF200008FC200FF88388F6200008F92000180028B79";  
   attribute INIT_1F of ram_1024_x_18 : label is "6600600188388D1966FF8E516600600088388D1966FF8D916600600088388E51";  
   attribute INIT_20 of ram_1024_x_18 : label is "8BF966006819672F883892720001915200FF90620000232188388D9166FF8D19";  
   attribute INIT_21 of ram_1024_x_18 : label is "90808BF94689C7018BF94769660097D991019391CA01C7014E414D394B414A39";  
   attribute INIT_22 of ram_1024_x_18 : label is "4B414A398BF946896814673088386B006A003B02800291321FFF44825F818C59";  
   attribute INIT_23 of ram_1024_x_18 : label is "4689C801C7018BF948714769660097D99391CA019211C8019101C7014E414D39";  
   attribute INIT_24 of ram_1024_x_18 : label is "681E673092906B006A00485947513B02800292421FFF44825F818C5991708BF9";  
   attribute INIT_25 of ram_1024_x_18 : label is "48714769660097D99391CA01933188019101C7014E414D394B414A398BF94689";  
   attribute INIT_26 of ram_1024_x_18 : label is "6A00485947513B02800293621FFF44825F818C5992908BF946898801C7018BF9";  
   attribute INIT_27 of ram_1024_x_18 : label is "5C825F889C018CB98B01959A5C825F8893DA4A689C018CB97C007B2091706B00";  
   attribute INIT_28 of ram_1024_x_18 : label is "9C018CB9CB01959A5C825F889C018CB98A01959A5C825F889C018CB98A01959A";  
   attribute INIT_29 of ram_1024_x_18 : label is "5C825F889C018CB9CA01959A5C825F889C018CB9CB01959A5C825F8894AA4A68";  
   attribute INIT_2A of ram_1024_x_18 : label is "41D34BD2DA0141D34AD2DA01800096621903959A5C815F889C018CB9CA01959A";  
   attribute INIT_2B of ram_1024_x_18 : label is "940A1C0293DA1C019B014ADB9B014BDB9A014AD39A014BD39D01800293989901";  
   attribute INIT_2C of ram_1024_x_18 : label is "4281620FB7101D02953A1C08950A1C0794DA1C0694AA1C05946A1C04943A1C03";  
   attribute INIT_2D of ram_1024_x_18 : label is "1B2079007D008BF941DB48DADB0141DB47DADB015B8162FA8BF9487147696600";  
   attribute INIT_2E of ram_1024_x_18 : label is "8C59883B939A5F8895921F008C59959097AA0001977A00FF974A000096A0883A";  
   attribute INIT_2F of ram_1024_x_18 : label is "76AAD50175AAD401740A883B939A5F8895921F008C59883B939A5F8895921F00";  
   attribute INIT_30 of ram_1024_x_18 : label is "A00390221E298F121E6B8F3A1E743E44A001800297E3340097F335009803D601";  
   attribute INIT_31 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_32 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_33 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_34 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_35 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_36 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_37 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_38 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_39 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3A of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3B of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3C of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3D of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3E of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  
   attribute INIT_3F of ram_1024_x_18 : label is "9838000000000000000000000000000000000000000000000000000000000000";  
   attribute INITP_00 of ram_1024_x_18 : label is "3F3CFCFCFCFCFCFCFCFCFCF3CFCF3F3F3CF3CFCFCFCFC3FCFF3FCFF100000000";  
   attribute INITP_01 of ram_1024_x_18 : label is "FFF3CF3F3CF3F3CF3CFCF3CF3CF3F3CF3CF3CF3CFCF3CF3F3F3F3F3F3F3FCFCF";  
   attribute INITP_02 of ram_1024_x_18 : label is "138F3D08908928008A020200220021228084FF4FF4FF4FF4FF4FF33333310FFF";  
   attribute INITP_03 of ram_1024_x_18 : label is "F0CF0CF0CF0CC334FCFCF3CF3CF4FCFCF3CF3CF4F3CFCFC9FC6809FC6809FC68";  
   attribute INITP_04 of ram_1024_x_18 : label is "C88C08F3C14FC0280C222000F3C14FC0280C222000F3D4FC020C0A003F0CCF0C";  
   attribute INITP_05 of ram_1024_x_18 : label is "EEC0300300303330FC082F03F3333333338888920824CC88C88C88C088C88C88";  
   attribute INITP_06 of ram_1024_x_18 : label is "000000000000000000000000000000000000000000000000000000004CCF5222";  
   attribute INITP_07 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";  


begin

   ----------------------------------------------------------------------
   --Instantiate the Xilinx primitive for a block RAM 
   --INIT values repeated to define contents for functional simulation 
   ----------------------------------------------------------------------
   ram_1024_x_18: RAMB16_S18 
   --synthesitranslate_off
   --INIT values repeated to define contents for functional simulation
   generic map ( 
          INIT_00 => X"0000000000000000000000000000000000000000000000000000000000008080",  
          INIT_01 => X"66FF692D680567048B7966FF6936682D67048B7966FF6936680567048BA9A000",  
          INIT_02 => X"670A8B796909683467048A2966FF682F67048D198B4966FF692D680567368B49",  
          INIT_03 => X"89D1684367048A29683E67048A29683967048B796909683767048B4969366835",  
          INIT_04 => X"670D8B49694B6849670A8BF9684967078B49694B684967048B79690968486705",  
          INIT_05 => X"6913683C670E8B7969136839670E8B49693B683A670D89D16834670D8A29682F",  
          INIT_06 => X"6940683F67108B79690F683E670E8B496941683F670D8B49693B683A67108B79",  
          INIT_07 => X"8B4969466844670D8BF96843670E8B496940683E67138B796912684167118B49",  
          INIT_08 => X"8B4966D0693868348B4966E06933682F67158B7969136845670D8BF96847670E",  
          INIT_09 => X"8B496687694C68488B496603694768438B49661C6942683E8B4966D8693D6839",  
          INIT_0A => X"6705681666D08BF9670A68138BF9670A68158BF9670968148BF96708681366D8",  
          INIT_0B => X"8BF96705681B8BF96706681B8BF9670768148BF9670668148BF9670668158BF9",  
          INIT_0C => X"8BF9670768118BF9670668128BF96705681266878BF96706681F8BF96705681E",  
          INIT_0D => X"8BF96708681F8BF96707681E66038BF96707681A8BF9670668198BF967056818",  
          INIT_0E => X"8BF9670968168BF9670868178BF967076818661C8BF9670A681D8BF96709681E",  
          INIT_0F => X"6A00690068006700650064008BF9670A681B8BF96709681A8BF96708681966E0",  
          INIT_10 => X"A910037EA8E00354A8B0032A8840A00088510000610060007F007E006C006B00",  
          INIT_11 => X"673968196687718780028BF967396819661C711CA9A003FFA97003D2A94003A8",  
          INIT_12 => X"66D071D080028BF96739681966E071E080028BF9673968196603710380028BF9",  
          INIT_13 => X"880147598B794B398905493980028BF96739681966D871D880028BF967396819",  
          INIT_14 => X"4C49890149418801496147598B794C494B398906493980028B49890249418706",  
          INIT_15 => X"890149398802C705485149618B498703485149618B498703485149618B494A41",  
          INIT_16 => X"890180028B53484888018BF9890180028B7989038703496147598B794C494B39",  
          INIT_17 => X"443980028BBB0A3C8A018B49694F680047516A00660080028B83474887018BF9",  
          INIT_18 => X"0401043F057F454144398C2825808002469244904591AC480401043F057F4541",  
          INIT_19 => X"3F9344904591AD080401043F057F455944518C88258080023F9344904591ACA8",  
          INIT_1A => X"681B67328BF9681767328B49691A681867318B796935681967308CE825808002",  
          INIT_1B => X"681D67318BF9681C67328BF9681B67338BF9681A67348BF96819673580028BF9",  
          INIT_1C => X"8BF9681867348BF96819673580028B796934681D67338B49691B681A67318BF9",  
          INIT_1D => X"6934681567338B496918681767318BF9681567318BF9681667328BF968176733",  
          INIT_1E => X"66FF8D19660060FF88388FF200008FC200FF88388F6200008F92000180028B79",  
          INIT_1F => X"6600600188388D1966FF8E516600600088388D1966FF8D916600600088388E51",  
          INIT_20 => X"8BF966006819672F883892720001915200FF90620000232188388D9166FF8D19",  
          INIT_21 => X"90808BF94689C7018BF94769660097D991019391CA01C7014E414D394B414A39",  
          INIT_22 => X"4B414A398BF946896814673088386B006A003B02800291321FFF44825F818C59",  
          INIT_23 => X"4689C801C7018BF948714769660097D99391CA019211C8019101C7014E414D39",  
          INIT_24 => X"681E673092906B006A00485947513B02800292421FFF44825F818C5991708BF9",  
          INIT_25 => X"48714769660097D99391CA01933188019101C7014E414D394B414A398BF94689",  
          INIT_26 => X"6A00485947513B02800293621FFF44825F818C5992908BF946898801C7018BF9",  
          INIT_27 => X"5C825F889C018CB98B01959A5C825F8893DA4A689C018CB97C007B2091706B00",  
          INIT_28 => X"9C018CB9CB01959A5C825F889C018CB98A01959A5C825F889C018CB98A01959A",  
          INIT_29 => X"5C825F889C018CB9CA01959A5C825F889C018CB9CB01959A5C825F8894AA4A68",  
          INIT_2A => X"41D34BD2DA0141D34AD2DA01800096621903959A5C815F889C018CB9CA01959A",  
          INIT_2B => X"940A1C0293DA1C019B014ADB9B014BDB9A014AD39A014BD39D01800293989901",  
          INIT_2C => X"4281620FB7101D02953A1C08950A1C0794DA1C0694AA1C05946A1C04943A1C03",  
          INIT_2D => X"1B2079007D008BF941DB48DADB0141DB47DADB015B8162FA8BF9487147696600",  
          INIT_2E => X"8C59883B939A5F8895921F008C59959097AA0001977A00FF974A000096A0883A",  
          INIT_2F => X"76AAD50175AAD401740A883B939A5F8895921F008C59883B939A5F8895921F00",  
          INIT_30 => X"A00390221E298F121E6B8F3A1E743E44A001800297E3340097F335009803D601",  
          INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",  
          INIT_3F => X"9838000000000000000000000000000000000000000000000000000000000000",  
          INITP_00 => X"3F3CFCFCFCFCFCFCFCFCFCF3CFCF3F3F3CF3CFCFCFCFC3FCFF3FCFF100000000",  
          INITP_01 => X"FFF3CF3F3CF3F3CF3CFCF3CF3CF3F3CF3CF3CF3CFCF3CF3F3F3F3F3F3F3FCFCF",  
          INITP_02 => X"138F3D08908928008A020200220021228084FF4FF4FF4FF4FF4FF33333310FFF",  
          INITP_03 => X"F0CF0CF0CF0CC334FCFCF3CF3CF4FCFCF3CF3CF4F3CFCFC9FC6809FC6809FC68",  
          INITP_04 => X"C88C08F3C14FC0280C222000F3C14FC0280C222000F3D4FC020C0A003F0CCF0C",  
          INITP_05 => X"EEC0300300303330FC082F03F3333333338888920824CC88C88C88C088C88C88",  
          INITP_06 => X"000000000000000000000000000000000000000000000000000000004CCF5222",  
          INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")  


   --synthesis translate_on
   port map(  DI => "0000000000000000",
             DIP => "00",
              EN => '1',
              WE => '0',
             SSR => '0',
             CLK => clk,
            ADDR => address,
              DO => INSTRUCTION(15 downto 0),
             DOP => INSTRUCTION(17 downto 16)); 

--
end low_level_definition;
--
----------------------------------------------------------------------
-- END OF FILE prog_rom.vhd
----------------------------------------------------------------------
