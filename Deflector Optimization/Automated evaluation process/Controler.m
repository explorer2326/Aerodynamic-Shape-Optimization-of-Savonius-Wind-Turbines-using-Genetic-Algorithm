function power = Controler(x)
x1 = x(1); x2 = x(2); x3 = x(3); y1 = x(4); y2 = x(5); y3 = x(6);
X = [x1 x2 x3];
Y = [y1 y2 y3];
I = [X Y];
Q = mat2str(I);
%IDENTIFIER
pause(10*rand(1));
tnow = datestr(now,'yymmddHHMMSSFFF');
ID = str2double(tnow);
%CHECK IF THE INPUT IS REPEATED
RECORD = dlmread ('RESULT.txt');
INPUT = RECORD(:,1:6);
OUTPUT = RECORD(:,7);
if sum(ismembertol(INPUT,I,0.001,'ByRows',true,'DataScale', 1)) ~= 0
    search = find(ismembertol(INPUT,I,0.001,'ByRows',true,'DataScale', 1));
    index = search(1);
    Cp = OUTPUT(index);
    %STORING DATA
    RESULT = [I Cp];
    dlmwrite('Result.txt', RESULT, '-append','delimiter',' ','roffset',0);
    power = -OUTPUT(index);
else  
% SKELETON
CURP = [x1 x2 x3;y1 y2 y3];
CURV = cscvn(CURP);
points = fnplt(CURV);
scatter(X,Y);
hold on;
circle(0,0,125,'k-');
fig1 = plot(points(1,:),points(2,:),'r-');
axis equal;
hold off;
curve=['Skeleton',tnow,Q,'.jpeg'];
saveas(fig1,curve);
%%GENERATE FORMATTED DATA POINTS
a = points(1,:);
f = points(2,:);
%INTERPOLATION OF SLOPE
num = length(points);
k(1) = (f(2)-f(1))/(a(2)-a(1));
k(num) = (f(num)-f(num-1))/(a(num)-a(num-1));
for pointid = 2:(num-1),
k(pointid) = (f(pointid+1)-f(pointid-1))/(a(pointid+1)-a(pointid-1));
end
%ELIMINATE NaN &INF
numnan = find(isnan(k));
if isempty(numnan) == 0
    k(numnan) = (k(numnan-1) + k(numnan+1))/2
end
numinf = find(isinf(k));
if isempty(numinf) == 0
    k(numinf) = (k(numinf-1) + k(numinf+1))/2
end
%OFFSET & FLIPING THE CURVE
change = 0;
for it=1:(num-1)
    if (k(it)*k(it+1)<0) && (abs(k(it)*k(it+1))>10)
      change= [change it];
    end
end
change = [change num];
for tflip = 1:(size(change,2)-1)
    for it=(change(tflip)+1):change(tflip+1)
        b1(it) = a(it)-(-1)^(tflip+1)*k(it)*sqrt(1/(1+k(it)^2));
        b2(it) = a(it)+(-1)^(tflip+1)*k(it)*sqrt(1/(1+k(it)^2));
        f1(it) = f(it)+(-1)^(tflip+1)*sqrt(1/(1+k(it)^2));
        f2(it) = f(it)-(-1)^(tflip+1)*sqrt(1/(1+k(it)^2));
    end
end
if k(num) > 0,
    if a(num)>a(num-1),
        t1x = (b1(num)+b2(num))/2+1/sqrt(1+k(num)^2);
        t1y = (f1(num)+f2(num))/2+k(num)/sqrt(1+k(num)^2);
    end
    if a(num)<a(num-1),
        t1x = (b1(num)+b2(num))/2-1/sqrt(1+k(num)^2);
        t1y = (f1(num)+f2(num))/2-k(num)/sqrt(1+k(num)^2);
    end
else if a(num)<a(num-1),
    t1x = (b1(num)+b2(num))/2-1/sqrt(1+k(num)^2);
    t1y = (f1(num)+f2(num))/2-k(num)/sqrt(1+k(num)^2);
    else
        t1x = (b1(num)+b2(num))/2+1/sqrt(1+k(num)^2);
        t1y = (f1(num)+f2(num))/2+k(num)/sqrt(1+k(num)^2);
    end
end

if k(1) > 0,
    t2x = (b1(1)+b2(1))/2-1/sqrt(1+k(1)^2);
    t2y = (f1(1)+f2(1))/2-k(1)/sqrt(1+k(1)^2);
else if a(1) > a(2),
    t2x = (b1(1)+b2(1))/2+1/sqrt(1+k(1)^2);
    t2y = (f1(1)+f2(1))/2+k(1)/sqrt(1+k(1)^2);
    else
        t2x = (b1(1)+b2(1))/2-1/sqrt(1+k(1)^2);
        t2y = (f1(1)+f2(1))/2-k(1)/sqrt(1+k(1)^2);
    end
end
%EXPORT POINT DATA
count = (num + 2);
B = [count t2x b1 t1x t2x b2 t1x]';
F = [2 t2y f1 t1y t2y f2 t1y]';
Z = zeros(2*count + 1,1);
export = [B F Z];
formatpointname = sprintf('formatted%d.txt', ID);
save (formatpointname,'export','-ascii');
%CHANGE ICEM SCRIPT FILE
% Read txt into cell C
fid1 = fopen('D:\THESIS\GA\deflector optimization\Automesh.rpl','r');
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
formatSpec1 = 'ic_geo_cre_geom_input {D:/THESIS/WORKINGSPACE/formatted%d.txt} 0.00001 input PNTS pnt CRVS {} SURFS {}';
C{26} = sprintf(formatSpec1,ID);
% Modify output path
formatSpec2 = 'ic_save_tetin %d.tin 0 0 {} {} 0 0 1';
C{192} = sprintf(formatSpec2,ID);
formatSpec4 = 'ic_save_unstruct %d.uns 1 {} {} {}';
C{195} = sprintf(formatSpec4,ID);
formatSpec5 = 'ic_boco_save %d.fbc';
C{200} = sprintf(formatSpec5,ID);
formatSpec6 = 'ic_boco_save_atr %d.atr';
C{201} = sprintf(formatSpec6,ID);
formatSpec7 = 'ic_save_project_file D:/THESIS/WORKINGSPACE/%d.prj {array\\ set\\ file_name\\ \\{ {    catia_dir .} {    parts_dir .} {    domain_loaded 1} {    cart_file_loaded 0} {    cart_file {}} {    domain_saved %d.uns} {    archive {}} {    med_replay {}} {    topology_dir .} {    ugparts_dir .} {    icons {{$env(ICEM_ACN)/lib/ai_env/icons} {$env(ICEM_ACN)/lib/va/EZCAD/icons} {$env(ICEM_ACN)/lib/icons} {$env(ICEM_ACN)/lib/va/CABIN/icons}}} {    tetin %d.tin} {    family_boco %d.fbc} {    prism_params OPT-115.prism_params} {    iges_dir .} {    solver_params_loaded 1} {    attributes_loaded 1} {    project_lock {}} {    attributes %d.atr} {    domain %d.uns} {    domains_dir .} {    settings_loaded 0} {    settings %d.prj} {    blocking {}} {    hexa_replay {}} {    transfer_dir .} {    mesh_dir .} {    family_topo {}} {    gemsparts_dir .} {    family_boco_loaded 1} {    tetin_loaded 1} {    project_dir .} {    topo_mulcad_out {}} {    solver_params {}} \\} array\\ set\\ options\\ \\{ {    expert 1} {    remote_path {}} {    tree_disp_quad 2} {    tree_disp_pyra 0} {    evaluate_diagnostic 0} {    histo_show_default 1} {    select_toggle_corners 0} {    remove_all 0} {    keep_existing_file_names 0} {    record_journal 1} {    edit_wait 0} {    face_mode all} {    select_mode all} {    med_save_emergency_tetin 1} {    user_name adamh} {    diag_which all} {    uns_warn_if_display 500000} {    bubble_delay 1000} {    external_num 1} {    tree_disp_tri 2} {    apply_all 1} {    default_solver {ANSYS Fluent}} {    temporary_directory C:/Users/adamh/AppData/Local/Temp} {    flood_select_angle 0} {    home_after_load 1} {    project_active 0} {    histo_color_by_quality_default 1} {    undo_logging 1} {    tree_disp_hexa 0} {    histo_solid_default 1} {    host_name DESKTOP-4P2AVLD} {    xhidden_full 1} {    editor notepad} {    mouse_color orange} {    clear_undo 1} {    remote_acn {}} {    remote_sh csh} {    tree_disp_penta 0} {    n_processors 1} {    remote_host {}} {    save_to_new 0} {    quality_info Quality} {    tree_disp_node 0} {    med_save_emergency_mesh 1} {    redtext_color red} {    tree_disp_line 0} {    select_edge_mode 0} {    use_dlremote 0} {    max_mesh_map_size 1024} {    show_tris 1} {    remote_user {}} {    enable_idle 0} {    auto_save_views 1} {    max_cad_map_size 512} {    display_origin 0} {    uns_warn_user_if_display 1000000} {    detail_info 0} {    win_java_help 0} {    show_factor 1} {    boundary_mode all} {    clean_up_tmp_files 1} {    auto_fix_uncovered_faces 1} {    med_save_emergency_blocking 1} {    max_binary_tetin 0} {    tree_disp_tetra 0} \\} array\\ set\\ disp_options\\ \\{ {    uns_dualmesh 0} {    uns_warn_if_display 500000} {    uns_normals_colored 0} {    uns_icons 0} {    uns_locked_elements 0} {    uns_shrink_npos 0} {    uns_node_type None} {    uns_icons_normals_vol 0} {    uns_bcfield 0} {    backup Solid/wire} {    uns_nodes 0} {    uns_only_edges 0} {    uns_surf_bounds 0} {    uns_wide_lines 0} {    uns_vol_bounds 0} {    uns_displ_orient Triad} {    uns_orientation 0} {    uns_directions 0} {    uns_thickness 0} {    uns_shell_diagnostic 0} {    uns_normals 0} {    uns_couplings 0} {    uns_periodicity 0} {    uns_single_surfaces 0} {    uns_midside_nodes 1} {    uns_shrink 100} {    uns_multiple_surfaces 0} {    uns_no_inner 0} {    uns_enums 0} {    uns_disp Solid/wire} {    uns_bcfield_name {}} {    uns_color_by_quality 0} {    uns_changes 0} {    uns_cut_delay_count 1000} \\} {set icon_size1 24} {set icon_size2 35} {set thickness_defined 0} {set solver_type 1} {set solver_setup 1} array\\ set\\ prism_values\\ \\{ {    n_triangle_smoothing_steps 5} {    min_smoothing_steps 6} {    first_layer_smoothing_steps 1} {    new_volume {}} {    height 0} {    prism_height_limit 0} {    interpolate_heights 0} {    n_tetra_smoothing_steps 10} {    do_checks {}} {    delete_standalone 1} {    ortho_weight 0.50} {    max_aspect_ratio {}} {    ratio_max {}} {    total_height 0} {    use_prism_v10 0} {    intermediate_write 1} {    delete_base_triangles {}} {    ratio_multiplier {}} {    refine_prism_boundary 1} {    max_size_ratio {}} {    triangle_quality {}} {    max_prism_angle 180} {    tetra_smooth_limit 0.30000001} {    max_jump_factor 5} {    use_existing_quad_layers 0} {    layers 3} {    fillet 0.1} {    into_orphan 0} {    init_dir_from_prev {}} {    blayer_2d 0} {    do_not_allow_sticking {}} {    top_family {}} {    law exponential} {    min_smoothing_val 0.1} {    auto_reduction 0} {    max_prism_height_ratio 0} {    stop_columns 1} {    stair_step 1} {    smoothing_steps 12} {    side_family {}} {    min_prism_quality 0.0099999998} {    ratio 1.2} \\} {set aie_current_flavor {}} array\\ set\\ vid_options\\ \\{ {    wb_import_tritol 0.001} {    wb_import_mix_res_line 0} {    wb_import_cad_att_pre {SDFEA;DDM}} {    wb_import_surface_bodies 1} {    wb_NS_to_subset 0} {    wb_import_mat_points 0} {    auxiliary 0} {    wb_import_mix_res_surface 0} {    wb_import_mix_res -1} {    wb_import_cad_att_trans 1} {    show_name 0} {    wb_import_delete_solids 0} {    wb_import_solid_bodies 1} {    wb_import_save_pmdb {}} {    wb_import_mix_res_solid 0} {    inherit 1} {    default_part GEOM} {    new_srf_topo 1} {    wb_import_associativity_model_name {}} {    DelPerFlag 0} {    edit_replay_filter 0} {    show_item_name 0} {    wb_import_save_partfile 0} {    wb_import_line_bodies 0} {    composite_tolerance 1.0} {    wb_import_en_sym_proc 1} {    wb_NS_to_entity_parts 0} {    wb_import_work_points 0} {    wb_import_sel_proc 1} {    wb_NS_only 0} {    wb_import_pluginname {}} {    wb_import_mix_res_point 0} {    wb_import_refresh_pmdb 0} {    wb_import_create_solids 0} {    wb_import_load_pmdb {}} {    wb_import_scale_geo 0} {    wb_import_sel_pre {}} {    replace 0} {    wb_import_cad_associativity 0} {    same_pnt_tol 1e-4} {    tdv_axes 1} {    vid_mode 0} {    DelBlkPerFlag 0} \\} array\\ set\\ map_tetin_sizes\\ \\{ {    densities 1} {    msurfaces 1} {    ppoint 1} {    thincuts 1} {    tetin {}} {    psurfaces 1} {    mcurves 1} {    mpoint 1} {    doit 0} {    pcurves 1} {    global 1} {    subsets 1} {    family 1} \\} array\\ set\\ import_model_options\\ \\{ {    from_source 0} {    always_convert 0} {    named_sel_only 0} {    always_import 0} {    convert_to {}} \\} {set savedTreeVisibility {geomNode 1 geom_subsetNode 0 geomPointNode 0 geomCurveNode 2 geomSurfNode 0 meshNode 1 mesh_subsetNode 2 meshPointNode 0 meshLineNode 2 meshShellNode 2 meshTriNode 2 meshQuadNode 2 partNode 2 part-ADVANCING 2 part-DEFLECTOR 2 part-GEOM 2 part-INLET 2 part-INTERFACE 2 part-OUTLET 2 part-PNTS 2 part-RETURNING 2 part-ROTATIONAL 2 part-SIDES 2 part-STATIONARY 2}} {set last_view {rot {0 0 0 1} scale {8.46777477266 8.46777477266 8.46777477266} center {750.0 0.0 0.0} pos {7117.14139159 -518.467253692 0}}} array\\ set\\ cut_info\\ \\{ {    active 0} {    whole 1} \\} array\\ set\\ hex_option\\ \\{ {    default_bunching_ratio 2.0} {    floating_grid 0} {    project_to_topo 0} {    n_tetra_smoothing_steps 20} {    sketching_mode 0} {    trfDeg 1} {    wr_hexa7 0} {    smooth_ogrid 0} {    find_worst 1-3} {    hexa_verbose_mode 0} {    old_eparams 0} {    uns_face_mesh_method uniform_quad} {    multigrid_level 0} {    uns_face_mesh one_tri} {    check_blck 0} {    proj_limit 0} {    check_inv 0} {    project_bspline 0} {    hexa_update_mode 1} {    default_bunching_law BiGeometric} \\} array\\ set\\ saved_views\\ \\{ {    views {}} \\}} {ICEM CFD}';
C{203} = sprintf(formatSpec7,ID,ID,ID,ID,ID,ID,ID);
formatSpec8 = 'ic_exec  {D:/ANSYS16/ANSYS Inc/v161/icemcfd/win64_amd/icemcfd/output-interfaces/fluent6} -dom D:/THESIS/WORKINGSPACE/%d.uns -b %d.fbc -dim2d ./%d';
C{204} = sprintf(formatSpec8,ID,ID,ID);
% Write cell C into txt
scriptname = sprintf('script%d.rpl',ID);
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
fid2 = fopen('D:\THESIS\GA\deflector optimization\Autosimulate.jou','r');
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
formatSpec11 = '(cx-gui-do cx-set-text-entry "Select File*Text" "%d.msh")';
A{12} = sprintf(formatSpec11,ID);
% Modify output path
formatSpec12 = '(cx-gui-do cx-set-text-entry "Force Moment Monitor*Frame1*Table1*Frame1*Table1*Frame1(Options)*Table1(Options)*Frame5*Table5*TextEntry2(File Name)" "CT%d")';
A{45} = sprintf(formatSpec12,ID);
% Write cell A into txt
journalname = sprintf('journal%d.jou', ID);
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
eval(['!"D:\ANSYS16\ANSYS Inc\v161\icemcfd\win64_amd\bin\icemcfd.bat" -batch -script D:\THESIS\WORKINGSPACE\script',tnow,'.rpl'])
eval(['!"D:\ANSYS16\ANSYS Inc\v161\fluent\ntbin\win64\fluent.exe" 2d -g -wait -i D:\THESIS\WORKINGSPACE\journal',tnow,'.jou'])
%POSTPROCESSOR
myfilename = sprintf('CT%d', ID);
M = dlmread (myfilename,'',[2 1 6 1]);
Cp = 80*mean(M);
Pc = mat2str(Cp);
u=(1:5);
fig2=plot(u,M,'r-');
ctname=['CT',Pc,datestr(now, 'yyyy-mmm-dd-HH-MM'),Q,'.jpeg'];
saveas(fig2,ctname);
power = -Cp;
%STORING DATA
RESULT = [I Cp];
dlmwrite('Result.txt', RESULT, '-append','delimiter',' ','roffset',0);
end
