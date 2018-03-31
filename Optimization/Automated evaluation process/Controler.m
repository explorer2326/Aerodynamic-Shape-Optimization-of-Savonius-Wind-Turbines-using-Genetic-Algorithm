function power = Controler(x)
x1 = x(1); x2 = x(2); x3 = x(3); y1 = x(4); y2 = x(5); y3 = x(6);
X = [x1 x2 x3];
Y = [y1 y2 y3];
I = [X Y]; 
%NUMBER OF EVALUATIONS & IDSENTIFIER
COUNTER = dlmread ('COUNTER.txt');
IDS = mat2str(COUNTER);
COUNTER = COUNTER+1;
dlmwrite('COUNTER.txt', COUNTER);
%CHECK IF THE INPUT IS REPEATED
RECORD = dlmread ('RESULT.txt');
INPUT = RECORD(:,1:6);
OUTPUT = RECORD(:,7);
if sum(ismember(INPUT,I,'rows')) ~= 0
    search = find(ismember(INPUT,I,'rows'));
    index = search(1);
    Cp = OUTPUT(index);
    %STORING DATA
    RESULT = [I Cp];
    dlmwrite('RESULT.txt', RESULT, '-append','delimiter',' ','roffset',0);
    power = -OUTPUT(index);
else  
%FUNCTION OF SKELETON LINE
M = [0, X, 100];
N = [0, Y, 0];
Q = mat2str(I);
p = polyfit(M,N,4);
a = linspace(0,100);
f = polyval(p,a);
fig1 = plot(a,f,'r-');
axis equal;
curve=['Skeleton',IDS,'.jpeg'];
saveas(fig1,curve);
%GENERATE FORMATTED DATA POINTS
k = 4*p(1)*a.^3 + 3*p(2)*a.^2 + 2*p(3)*a + p(4);
b1 = a-k.*sqrt(1./(1+k.^2));
b2 = a+k.*sqrt(1./(1+k.^2));
f1 = f+sqrt(1./(1+k.^2));
f2 = f-sqrt(1./(1+k.^2));
b3 = fliplr(-b1);
b4 = fliplr(-b2);
f3 = fliplr(-f1);
f4 = fliplr(-f2);
t1x = (b1(100)+b2(100))/2+1/sqrt(1+k(100)^2);
t1y = (f1(100)+f2(100))/2+k(100)/sqrt(1+k(100)^2);
t2x = -t1x;
t2y = -t1y;
B = [202 t2x b4 b1 t1x t2x b3 b2 t1x]';
F = [2 t2y f4 f1 t1y t2y f3 f2 t1y]';
Z = zeros(405,1);
export = [B F Z];
formatpointname = sprintf('formatted%s.txt', IDS);
save (formatpointname,'export','-ascii');
%CHANGE ICEM SCRIPT FILE
% Read txt into cell C
fid1 = fopen('D:\Adam\Blade shape optimization\Optimization\Automated evaluation process\Automesh.rpl','r');
i = 1;
tline = fgetl(fid1);
C{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid1);
   C{i} = tline;
end
fclose(fid1);
% Change cell C
% Modify input path
formatSpec1 = 'ic_geo_cre_geom_input {D:/matlabfile/GAFILES/formatted%s.txt} 0.00001 input PNTS pnt CRVS crv SURFS {}';
C{2} = sprintf(formatSpec1,IDS);
% Modify output path
formatSpec2 = 'ic_save_tetin %s.tin 0 0 {} {} 0 0 1';
C{346} = sprintf(formatSpec2,IDS);
formatSpec3 = 'ic_rename %s.uns %s.uns.bak';
C{347} = sprintf(formatSpec3,IDS,IDS);
formatSpec4 = 'ic_save_unstruct %s.uns 1 {} {} {}';
C{350} = sprintf(formatSpec4,IDS);
formatSpec5 = 'ic_boco_save %s.fbc';
C{355} = sprintf(formatSpec5,IDS);
formatSpec6 = 'ic_boco_save_atr %s.atr';
C{356} = sprintf(formatSpec6,IDS);
formatSpec7 = 'ic_save_project_file D:/matlabfile/GAFILES/%s.prj {array\\ set\\ file_name\\ \\{ {    catia_dir .} {    parts_dir .} {    domain_loaded 0} {    cart_file_loaded 0} {    cart_file {}} {    domain_saved %s.uns} {    archive {}} {    med_replay {}} {    topology_dir .} {    ugparts_dir .} {    icons {{$env(ICEM_ACN)/lib/ai_env/icons} {$env(ICEM_ACN)/lib/va/EZCAD/icons} {$env(ICEM_ACN)/lib/icons} {$env(ICEM_ACN)/lib/va/CABIN/icons}}} {    tetin %s.tin} {    family_boco %s.fbc} {    iges_dir .} {    solver_params_loaded 0} {    attributes_loaded 0} {    project_lock {}} {    attributes %s.atr} {    domain %s.uns} {    domains_dir .} {    settings_loaded 0} {    settings %s.prj} {    blocking {}} {    hexa_replay {}} {    transfer_dir .} {    mesh_dir .} {    family_topo {}} {    gemsparts_dir .} {    family_boco_loaded 0} {    tetin_loaded 0} {    project_dir .} {    topo_mulcad_out {}} {    solver_params {}} \\} array\\ set\\ options\\ \\{ {    expert 1} {    remote_path {}} {    tree_disp_quad 2} {    tree_disp_pyra 0} {    evaluate_diagnostic 0} {    histo_show_default 1} {    select_toggle_corners 0} {    remove_all 0} {    keep_existing_file_names 0} {    record_journal 1} {    edit_wait 0} {    face_mode all} {    select_mode all} {    med_save_emergency_tetin 1} {    user_name adamh} {    diag_which all} {    uns_warn_if_display 500000} {    bubble_delay 1000} {    external_num 1} {    tree_disp_tri 2} {    apply_all 1} {    default_solver {ANSYS Fluent}} {    temporary_directory C:/Users/adamh/AppData/Local/Temp} {    flood_select_angle 0} {    home_after_load 1} {    project_active 0} {    histo_color_by_quality_default 1} {    undo_logging 1} {    tree_disp_hexa 0} {    histo_solid_default 1} {    host_name DESKTOP-4P2AVLD} {    xhidden_full 1} {    editor notepad} {    mouse_color orange} {    clear_undo 1} {    remote_acn {}} {    remote_sh csh} {    tree_disp_penta 0} {    n_processors 1} {    remote_host {}} {    save_to_new 0} {    quality_info Quality} {    tree_disp_node 0} {    med_save_emergency_mesh 1} {    redtext_color red} {    tree_disp_line 0} {    select_edge_mode 0} {    use_dlremote 0} {    max_mesh_map_size 1024} {    show_tris 1} {    remote_user {}} {    enable_idle 0} {    auto_save_views 1} {    max_cad_map_size 512} {    display_origin 0} {    uns_warn_user_if_display 1000000} {    detail_info 0} {    win_java_help 0} {    show_factor 1} {    boundary_mode all} {    clean_up_tmp_files 1} {    auto_fix_uncovered_faces 1} {    med_save_emergency_blocking 1} {    max_binary_tetin 0} {    tree_disp_tetra 0} \\} array\\ set\\ disp_options\\ \\{ {    uns_dualmesh 0} {    uns_warn_if_display 500000} {    uns_normals_colored 0} {    uns_icons 0} {    uns_locked_elements 0} {    uns_shrink_npos 0} {    uns_node_type None} {    uns_icons_normals_vol 0} {    uns_bcfield 0} {    backup Solid/wire} {    uns_nodes 0} {    uns_only_edges 0} {    uns_surf_bounds 0} {    uns_wide_lines 0} {    uns_vol_bounds 0} {    uns_displ_orient Triad} {    uns_orientation 0} {    uns_directions 0} {    uns_thickness 0} {    uns_shell_diagnostic 0} {    uns_normals 0} {    uns_couplings 0} {    uns_periodicity 0} {    uns_single_surfaces 0} {    uns_midside_nodes 1} {    uns_shrink 100} {    uns_multiple_surfaces 0} {    uns_no_inner 0} {    uns_enums 0} {    uns_disp Solid/wire} {    uns_bcfield_name {}} {    uns_color_by_quality 0} {    uns_changes 0} {    uns_cut_delay_count 1000} \\} {set icon_size1 24} {set icon_size2 35} {set thickness_defined 0} {set solver_type 1} {set solver_setup -1} array\\ set\\ prism_values\\ \\{ {    n_triangle_smoothing_steps 5} {    min_smoothing_steps 6} {    first_layer_smoothing_steps 1} {    new_volume {}} {    height {}} {    prism_height_limit {}} {    interpolate_heights 0} {    n_tetra_smoothing_steps 10} {    do_checks {}} {    delete_standalone 1} {    ortho_weight 0.50} {    max_aspect_ratio {}} {    ratio_max {}} {    total_height {}} {    use_prism_v10 0} {    intermediate_write 1} {    delete_base_triangles {}} {    ratio_multiplier {}} {    refine_prism_boundary 1} {    max_size_ratio {}} {    triangle_quality {}} {    max_prism_angle 180} {    tetra_smooth_limit 0.3} {    max_jump_factor 5} {    use_existing_quad_layers 0} {    layers 3} {    fillet 0.10} {    into_orphan 0} {    init_dir_from_prev {}} {    blayer_2d 0} {    do_not_allow_sticking {}} {    top_family {}} {    law exponential} {    min_smoothing_val 0.1} {    auto_reduction 0} {    stop_columns 1} {    stair_step 1} {    smoothing_steps 12} {    side_family {}} {    min_prism_quality 0.01} {    ratio 1.2} \\} {set aie_current_flavor {}} array\\ set\\ vid_options\\ \\{ {    wb_import_tritol 0.001} {    wb_import_mix_res_line 0} {    wb_import_cad_att_pre {SDFEA;DDM}} {    wb_import_surface_bodies 1} {    wb_NS_to_subset 0} {    wb_import_mat_points 0} {    auxiliary 0} {    wb_import_mix_res_surface 0} {    wb_import_mix_res -1} {    wb_import_cad_att_trans 1} {    show_name 0} {    wb_import_delete_solids 0} {    wb_import_solid_bodies 1} {    wb_import_save_pmdb {}} {    wb_import_mix_res_solid 0} {    inherit 1} {    default_part GEOM} {    new_srf_topo 1} {    wb_import_associativity_model_name {}} {    DelPerFlag 0} {    edit_replay_filter 0} {    show_item_name 0} {    wb_import_save_partfile 0} {    wb_import_line_bodies 0} {    composite_tolerance 1.0} {    wb_import_en_sym_proc 1} {    wb_NS_to_entity_parts 0} {    wb_import_work_points 0} {    wb_import_sel_proc 1} {    wb_NS_only 0} {    wb_import_pluginname {}} {    wb_import_mix_res_point 0} {    wb_import_refresh_pmdb 0} {    wb_import_create_solids 0} {    wb_import_load_pmdb {}} {    wb_import_scale_geo 0} {    wb_import_sel_pre {}} {    replace 0} {    wb_import_cad_associativity 0} {    same_pnt_tol 1e-4} {    tdv_axes 1} {    vid_mode 0} {    DelBlkPerFlag 0} \\} array\\ set\\ map_tetin_sizes\\ \\{ {    densities 1} {    msurfaces 1} {    ppoint 1} {    thincuts 1} {    tetin {}} {    psurfaces 1} {    mcurves 1} {    mpoint 1} {    doit 0} {    pcurves 1} {    global 1} {    subsets 1} {    family 1} \\} array\\ set\\ import_model_options\\ \\{ {    from_source 0} {    always_convert 0} {    named_sel_only 0} {    always_import 0} {    convert_to {}} \\} {set savedTreeVisibility {geomNode 1 geom_subsetNode 2 geomPointNode 0 geomCurveNode 2 geomSurfNode 2 meshNode 1 mesh_subsetNode 2 meshPointNode 0 meshLineNode 2 meshShellNode 2 meshTriNode 2 meshQuadNode 2 partNode 2 part-BLADES 2 part-GEOM 2 part-INLET 2 part-INTERFACE 2 part-OUTLET 2 part-PNTS 2 part-ROTATIONAL 2 part-SIDES 2 part-STATIONARY 2}} {set last_view {rot {0 0 0 1} scale {0.269483333333 0.269483333333 0.269483333333} center {750.0 0.0 0.0} pos {0 0 0}}} array\\ set\\ cut_info\\ \\{ {    active 0} \\} array\\ set\\ hex_option\\ \\{ {    default_bunching_ratio 2.0} {    floating_grid 0} {    project_to_topo 0} {    n_tetra_smoothing_steps 20} {    sketching_mode 0} {    trfDeg 1} {    wr_hexa7 0} {    smooth_ogrid 0} {    find_worst 1-3} {    hexa_verbose_mode 0} {    old_eparams 0} {    uns_face_mesh_method uniform_quad} {    multigrid_level 0} {    uns_face_mesh one_tri} {    check_blck 0} {    proj_limit 0} {    check_inv 0} {    project_bspline 0} {    hexa_update_mode 1} {    default_bunching_law BiGeometric} \\} array\\ set\\ saved_views\\ \\{ {    views {}} \\}} {ICEM CFD}';
C{358} = sprintf(formatSpec7,IDS,IDS,IDS,IDS,IDS,IDS,IDS);
formatSpec8 = 'ic_exec {C:/Program Files/ANSYS Inc/v160/icemcfd/win64_amd/icemcfd/output-interfaces/fluent6} -dom D:/matlabfile/GAFILES/%s.uns -b %s.fbc -dim2d ./%s';
C{360} = sprintf(formatSpec8,IDS,IDS,IDS);
formatSpec9 = 'ic_chdir D:/matlabfile/GAFILES';
C{343} = sprintf(formatSpec9);
% Write cell C into txt
scriptname = sprintf('script%s.rpl',IDS);
fid1 = fopen(scriptname, 'w');
for i = 1:numel(C)
    if C{i+1} == -1
        fprintf(fid1,'%s', C{i});
        break
    else
        fprintf(fid1,'%s\r\n', C{i});
    end
end
%CHANGE FLUENT JOURNAL FILE
% Read txt into cell A
fid2 = fopen('D:\Adam\Blade shape optimization\Optimization\Automated evaluation process\Autosimulate.jou','r');
i = 1;
tline = fgetl(fid2);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid2);
    A{i} = tline;
end
fclose(fid2);
% Change cell A
% Modify input path
formatSpec10 = '(cx-gui-do cx-set-text-entry "Select File*FilterText" "d:\\matlabfile\\GAFILES\\*")';
A{2} = sprintf(formatSpec10);
formatSpec11 = '(cx-gui-do cx-set-text-entry "Select File*Text" "%s.msh")';
A{4} = sprintf(formatSpec11,IDS);
% Modify output path
formatSpec12 = '(cx-gui-do cx-set-text-entry "Force Moment Monitor*Frame1*Table1*Frame1*Table1*Frame1(Options)*Table1(Options)*Frame5*Table5*TextEntry2(File Name)" "CT%s")';
A{81} = sprintf(formatSpec12,IDS);
% Write cell A into txt
journalname = sprintf('journal%s.jou', IDS);
fid2 = fopen(journalname, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid2,'%s', A{i});
        break
    else
        fprintf(fid2,'%s\r\n', A{i});
    end
end
%RUN ICEM & FLUENT
eval(['!"D:\ANSYS16\ANSYS Inc\v161\icemcfd\win64_amd\bin\icemcfd.bat" -batch -script D:\matlabfile\GAFILES\script',IDS,'.rpl'])
eval(['!"D:\ANSYS16\ANSYS Inc\v161\fluent\ntbin\win64\fluent.exe" 2d -g -wait -i D:\matlabfile\GAFILES\journal',IDS,'.jou'])
%POSTPROCESSOR
myfilename = sprintf('CT%s', IDS);
M = dlmread (myfilename,'',[11 1 20 1]);
Cp = 80*mean(M);
Pc = mat2str(Cp);
u=2*(1:10);
fig2=plot(u,M,'r-');
ctname=['CT',Pc,IDS,'.jpeg'];
saveas(fig2,ctname);
power = -Cp;
%STORING DATA
RESULT = [I Cp];
dlmwrite('RESULT.txt', RESULT, '-append','delimiter',' ','roffset',0);
end
