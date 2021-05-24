onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /wwhcpu/pc
add wave -noupdate -radix hexadecimal {/wwhcpu/regfile0/rf[5]}
add wave -noupdate -radix hexadecimal {/wwhcpu/regfile0/rf[6]}
add wave -noupdate -radix hexadecimal {/wwhcpu/regfile0/rf[7]}
add wave -noupdate -radix hexadecimal {/wwhcpu/regfile0/rf[8]}
add wave -noupdate -radix hexadecimal {/wwhcpu/regfile0/rf[9]}
add wave -noupdate {/wwhcpu/regfile0/rf[27]}
add wave -noupdate {/wwhcpu/regfile0/rf[28]}
add wave -noupdate -radix hexadecimal {/wwhcpu/dmem0/RAM[0]}
add wave -noupdate -radix hexadecimal /wwhcpu/instr
add wave -noupdate -radix hexadecimal /wwhcpu/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {137 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {66 ns} {540 ns}
