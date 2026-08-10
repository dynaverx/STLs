// ############################################################################
// # CENTER CAP - TAM PARAMETRIK  
// # parametrik snap-fit tirnaklar. Mesh bagimliligi yok.
// # Snap tirnak: smooth GIRIS rampasi + BEL (esneme boynu) + BARB/YAKALAMA.
// ############################################################################

/* [Disk / kubbe -, rotate_extrude ile uretilir] */
kapak_cy    = 30.71;   // disk merkezi Y  (eksen = X)   [tirnak yerlesimi icin]
kapak_cz    = 30.70;   // disk merkezi Z
disk_cap    = 61.40;   // *** dis cap [mm] ***
disk_arka_x = 5.00;    // arka yuz X (tirnak tabani duzlemi)
disk_kenar_x= 6.60;    // kubbenin KENARDAKI yuksekligi X
disk_tepe_x = 8.25;    // kubbe TEPE (merkez) X
disk_ici_bosalt = false; // arkadan kubbe cebi ac (malzeme azalt)
disk_cidar   = 2.0;    // bosaltinca cidar kalinligi [mm]
disk_dis_r  = disk_cap/2;   // dis yaricap (barb bunu asmasin)

/* [YENI SNAP-FIT TIRNAK - ana parametreler] */
tab_sayisi        = 6;      // tirnak sayisi
tab_oturma_capi   = 57.0;    // *** BARB'IN OTURDUGU CAP [mm] (kavrama capi) ***
tab_teget         = 10.0;     // tegetsel genislik [mm]
tab_aci0          = 7;       // ilk tirnak acisi [deg]
tab_taban_x       = 5.2;     // taban govdeye baglanti X'i

/* [Snap profil - kesit sekli (buyume buradan)] */
tab_boy           = 12.5;     // eksenel boy / cikinti L [mm]  (uzun = daha cok esner)
taban_kalinlik    = 1.0;     // taban radyal kalinlik [mm]
bel_kalinlik      = 2.0;     // BEL (waist) kalinlik [mm]  (ince = kolay esner)
barb_cikinti      = 1.2;     // barb'in tabandan disari cikmasi [mm] (kavrama)
barb_tepe         = 0.6;     // barb duz tepe uzunlugu [mm] (keskin uc olmasin)
uc_kalinlik       = 0.9;     // uc kalinlik [mm]
giris_rampa       = 3.2;     // smooth GIRIS rampasi uzunlugu [mm] (lead-in)
yakalama_boyu     = 0.7;     // YAKALAMA yuzu uzunlugu [mm] (kisa = dik tutma)
taban_uzunluk     = 1.6;     // taban bolgesi eksenel uzunluk [mm]
bel_baslangic     = 2.6;     // bel baslangic eksenel konum [mm]
tab_gomme         = 1.2;     // tabanin govde icine gomulme payi [mm]
tab_yuvarlat      = 0.4;     // kenar yuvarlatma (0 = keskin)

/* [Taban guclendirme - KOK gusset; her yon AYRI, 0 = o yone cizme] */
// Tab RADYAL buruluyor (barb ic/dis). Bukulme gerilmesi kokte, DIS (barb) yuzde.
// UYARI: guc_boy, bel_baslangic'ten KUCUK olmali; yoksa bel'i (esneme boynunu)
//        kalinlastirip tirnagi kilitler.
taban_guc_aktif   = true;
guc_boy           = 2.2;     // kokten yukselme uzunlugu [mm] (< bel_baslangic!)
guc_radyal_dis    = 1.4;     // DIS (barb / gerilme) yone rampa [mm]   << ana guclendirme
guc_radyal_ic     = 0.0;     // IC (merkez) yone rampa [mm]            (0 = yok)
guc_teget         = 0.0;     // tegetsel her yana [mm]                 (0 = yok)

$fn = 64;

// --- snap-fit kesit profili (X=eksenel, Y=radyal) -------------------------
function snap_poly() = let(
    L  = tab_boy,
    qg = taban_kalinlik + barb_cikinti,      // barb tepe (radyal)
    sr = tab_oturma_capi/2,                  // seat yaricap (barb tepesi burada)
    g  = tab_gomme,
    // (a = tabandan uca eksenel; q = ic yuzden disa radyal). barb tepesi = qg
    P = [
        [-g, 0],                                     // taban ic (gomulu)
        [ L, 0],                                     // uc ic
        [ L, uc_kalinlik],                           // uc dis
        [ L - giris_rampa, qg],                      // BARB tepe - on (lead-in ustu)
        [ L - giris_rampa - barb_tepe, qg],          // BARB duz tepe - arka
        [ L - giris_rampa - barb_tepe - yakalama_boyu, bel_kalinlik], // YAKALAMA (dik dusus)
        [ bel_baslangic, bel_kalinlik],              // BEL (ince boyun)
        [ taban_uzunluk, taban_kalinlik],            // taban dis rampa
        [-g, taban_kalinlik]                         // taban dis (gomulu)
    ]
) [ for (p = P) [ tab_taban_x - p[0], sr - qg + p[1] ] ];  // -> dunya X(eksenel)-Y(radyal)

module snap_tab(theta) {
    translate([0, kapak_cy, kapak_cz])
    rotate([theta, 0, 0])
    linear_extrude(height = tab_teget, center = true)
        if (tab_yuvarlat > 0) offset(r = tab_yuvarlat) offset(delta = -tab_yuvarlat) polygon(snap_poly());
        else polygon(snap_poly());
}

// --- PARAMETRIK KUBBELI DISK (rotate_extrude) ------------
module disk_solid() {
    R   = disk_cap/2;
    sag = disk_tepe_x - disk_kenar_x;                 // kubbe yuksekligi (sagitta)
    Rd  = (R*R + sag*sag) / (2*sag);                  // kubbe (kure) yaricapi
    cx  = disk_tepe_x - Rd;                           // kubbe merkezi (eksende)
    n   = 48;
    arc = [ for (i = [0:n]) let (r = R*(1 - i/n)) [ r, cx + sqrt(max(Rd*Rd - r*r, 0)) ] ];
    prof = concat([[0, disk_arka_x], [R, disk_arka_x], [R, disk_kenar_x]], arc);
    translate([0, kapak_cy, kapak_cz]) rotate([0,90,0])
        rotate_extrude($fn = 160) polygon(prof);
}
module disk_cep() {  // arkadan malzeme azaltma cebi
    x0 = disk_arka_x - 0.1;
    x1 = disk_tepe_x - disk_cidar;
    translate([0, kapak_cy, kapak_cz]) rotate([0,90,0]) translate([0,0,x0])
        linear_extrude(height = x1 - x0) circle(r = disk_cap/2 - disk_cidar, $fn=160);
}
module disk() {
    if (disk_ici_bosalt) difference() { disk_solid(); disk_cep(); }
    else disk_solid();
}

// tirnak dibi guclendirmesi: genis kokten dar tirnaga smooth gecen gusset
module _guc_slab(theta, x, w, ri, ro) {
    translate([0, kapak_cy, kapak_cz]) rotate([theta, 0, 0])
    translate([x, (ri + ro)/2, 0])
    cube([0.8, ro - ri, w], center=true);   // X=eksenel(ince), Y=radyal, Z=tegetsel(w)
}
module tab_guc(theta) {
    sr = tab_oturma_capi/2;
    ri = sr - (taban_kalinlik + barb_cikinti);   // ic yuz
    ro = ri + taban_kalinlik;                     // taban dis yuz
    hull() {
        // genis kok (diske gomulu) - istenen yonlere tasar
        _guc_slab(theta, tab_taban_x + 0.3, tab_teget + 2*guc_teget,
                  ri - guc_radyal_ic, ro + guc_radyal_dis);
        // tirnak boyunca disari, normal kesit (smooth gecis)
        _guc_slab(theta, tab_taban_x - guc_boy, tab_teget, ri, ro);
    }
}

union() {
    disk();                                   // parametrik disk
    for (i = [0 : tab_sayisi - 1]) {
        aci = tab_aci0 + i * 360/tab_sayisi;
        snap_tab(aci);
        if (taban_guc_aktif) tab_guc(aci);
    }
}
