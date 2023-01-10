+++
title = "Reading PVSyst's Module (PAN) and Inverter (OND) files with Python"
author = ["Guilherme Pedrosa"]
date = 2023-01-10T04:22:00-03:00
tags = ["python", "pvlib", "solar"]
draft = false
+++

Before diving into solar simulations with [PVLib](https://pvlib-python.readthedocs.io/en/stable/), one of the main concerns I had was how to use the same inputs given to PVSyst, the _de facto_ standard software of the solar industry. That also meant using the same files that describe the main equipments: ****PAN**** files for the modules and ****OND**** files for the inverters.

Although It surprised me that PVLib did not come with a PVSyst file's parser, It was not a deal breaker. The search for such a parser led me to [pvsyst_tools](https://github.com/frivollier/pvsyst_tools). The library worked perfectly for the PAN file I had at hand. Here's a quick demo loading the library and PAN file from a local folder:

```python
import os, sys

spath = '~/Projects/solar/'
print('current workign directory: {}'.format(spath))
sys.path.append(os.path.join(spath,'libs'))

import pvsyst
print('pvsyst module path: {}'.format(pvsyst.__file__))

import logging
logger = logging.getLogger('pysyst')
logger.setLevel(10)  # 5 for Verbose 10 for Debug

pan = os.path.join(spath,'refs','CS6W-545MB-AG_CSI_EXT_1500V_V7_10_20210419.PAN')  # example PAN file

# parse .PAN file into dict
module_parameters = pvsyst.pan_to_module_param(pan)  # return two dicts

module_parameters
```

```nil
{'Manufacturer': 'CSI Solar Co., Ltd.',
 'Model': 'CS6W-545MB-AG 1500V',
 'Technol': 'mtSiMono',
 'DataSource': 'Manufacture 2020 TUV-SUD data',
 'YearBeg': '2020',
 'Comment': 'www.csisolar.com',
 'Width': 1.134,
 'Height': 2.266,
 'Depth': 0.035,
 'Weight': 32.2,
 'RelEffic800': 0.27,
 'RelEffic400': -0.21,
 'RelEffic200': -1.8,
 'NCelS': 72,
 'NCelP': 2,
 'NDiode': 3,
 'GRef': 1000.0,
 'TRef': 25.0,
 'PNom': 545.0,
 'PNomTolLow': '0.00',
 'PNomTolUp': '1.80',
 'Isc': 13.95,
 'Voc': 49.4,
 'Imp': 13.14,
 'Vmp': 41.5,
 'muISC': 6.98,
 'muVocSpec': -128.4,
 'mIsc_percent': 0.05003584229390681,
 'mVoc_percent': -0.259919028340081,
 'muPmpReq': -0.34,
 'RShunt': 2500.0,
 'Rp_0': 10000.0,
 'Rp_Exp': 5.5,
 'RShunt_stc': 2530.6507857884803,
 'RSerie': 0.206,
 'Gamma': 0.98,
 'muGamma': -0.0004,
 'REM_Str_1': 'Frame: Anodized aluminium alloy',
 'REM_Str_2': 'Structure: 2.0mm Glass / EVA / 2.0mm Glass',
 'REM_Str_3': 'Connections: Cable,T4 series or H4 UTX or MC4-EVO2',
 'IAM_Point_1': '20.0,1.00000',
 'IAM_Point_2': '40.0,1.00000',
 'IAM_Point_3': '60.0,1.00000',
 'IAM_Point_4': '65.0,0.99000',
 'IAM_Point_5': '70.0,0.96000',
 'IAM_Point_6': '75.0,0.92000',
 'IAM_Point_7': '80.0,0.84000',
 'IAM_Point_8': '85.0,0.72000',
 'IAM_Point_9': '90.0,0.00000',
 'IAM': array([[20.  , 40.  , 60.  , 65.  , 70.  , 75.  , 80.  , 85.  , 90.  ],
        [ 1.  ,  1.  ,  1.  ,  0.99,  0.96,  0.92,  0.84,  0.72,  0.  ]]),
 'OperPoint_Point_1': 'False,800,25.0,0.27,0.00,0.000,0.000,0.00',
 'OperPoint_Point_2': 'False,600,25.0,0.14,0.00,0.000,0.000,0.00',
 'OperPoint_Point_3': 'False,400,25.0,-0.21,0.00,0.000,0.000,0.00',
 'OperPoint_Point_4': 'False,200,25.0,-1.80,0.00,0.000,0.000,0.00',
 'I_o_ref': 2.0352320417866327e-11,
 'EgRef': 1.121,
 'manufacturer': 'CSI Solar Co., Ltd.',
 'module_name': 'CS6W-545MB-AG 1500V',
 'Pmpp': 545.0,
 'Impp': 13.14,
 'Vmpp': 41.5,
 'mIsc': 0.00698,
 'mVocSpec': -0.12840000000000001,
 'mPmpp': -0.34,
 'Rshunt': 2500.0,
 'Rsh 0': 10000.0,
 'Rshexp': 5.5,
 'Rserie': 0.206,
 'gamma_ref': 0.98,
 'mu_gamma': -0.0004,
 'I_L_ref': 13.95,
 'R_sh_ref': 2530.6507857884803,
 'R_sh_0': 10000.0,
 'R_s': 0.206,
 'R_sh_exp': 5.5,
 'cells_in_series': 72,
 'alpha_sc': 0.00698}
```

To parse the OND file, however, I had to patch the `inverter.py` file from the _pvsyst_tools_ library to include an extra section called `ProfilPIO`. That is why I decided to load the library form a local copy in the previous example. Here's the patch:

```python
ond_sections ={'PVObject_': 'pvGInverter',
               'PVObject_Commercial': 'pvCommercial',
               'Converter': 'TConverter',
               'Remarks, Count': 'Remarks',
               'ProfilPIO': 'ProfilPIO',
               'ProfilPIOV1': 'ProfilPIOV1',
               'ProfilPIOV2': 'ProfilPIOV2',
               'ProfilPIOV3': 'ProfilPIOV3'}
```

With this patch in place, the same logic and procedure was applied to retrieve the inverter parameters:

```python
ond_dir = r'refs'  # directory of OND files}
ond = os.path.join(spath,ond_dir,'Sungrow_SG3125HV-30_V50_20200903_PVsyst.6.6.7.OND')  # example PAN file

# parse .OND file into dict
inverter_parameters = pvsyst.ond_to_inverter_param(ond)  # return two dicts

inverter_parameters
```

```nil
{'pvGInverter': {'Comment': 'Sungrow\tSG3125HV-30\tManufacturer 2020',
  'Version': '6.67',
  'ParObj1': '2020',
  'Flags': '$003C1463',
  'pvCommercial': {'Comment': 'Sungrow Power Supply Co., Ltd',
   'Flags': '$0041',
   'Manufacturer': 'Sungrow',
   'Model': 'SG3125HV-30',
   'DataSource': 'Manufacturer 2020',
   'YearBeg': '2020',
   'Width': '2.250',
   'Height': '2.350',
   'Depth': '1.160',
   'Weight': '2700.00',
   'NPieces': '100',
   'PriceDate': '26/11/15 14:00',
   'Currency': 'EUR'},
  'Transfo': 'Without',
  'TConverter': {'PNomConv': '3125.000',
   'PMaxOUT': '3437.000',
   'VOutConv': '600.0',
   'VMppMin': '875',
   'VMPPMax': '1300',
   'VmppNom': '1100.0',
   'VAbsMax': '1500',
   'PSeuil': '3125.0',
   'EfficMax': '99.00',
   'EfficEuro': '98.70',
   'FResNorm': '3.00',
   'ModeOper': 'MPPT',
   'CompPMax': 'Lim',
   'CompVMax': 'Lim',
   'MonoTri': 'Tri',
   'ModeAffEnum': 'Efficiencyf_POut',
   'UnitAffEnum': 'kW',
   'IDCMax': '0.0',
   'INomAC': '3007.0',
   'IMaxAC': '3308.0',
   'TPNom': '50.0',
   'TPMax': '45.0',
   'TPLim1': '52.0',
   'TPLimAbs': '60.0',
   'PLim1': '2500.000',
   'PInEffMax ': '952507.900',
   'PThreshEff': '5673.4',
   'HasdefaultPThresh': 'False',
   'ProfilPIO': {'NPtsMax': '11',
    'NPtsEff': '8',
    'LastCompile': '$8089',
    'Mode': '1',
    'Point_1': '12500.0,0.0',
    'Point_2': '75000.0,69249.5',
    'Point_3': '125000.0,119172.4',
    'Point_4': '250000.0,243901.1',
    'Point_5': '500000.0,493020.8',
    'Point_6': '750000.0,741690.6',
    'Point_7': '1500000.0,1485000.0',
    'Point_8': '2500000.0,2469779.2',
    'Point_9': '0.0,0.0',
    'Point_10': '0.0,0.0',
    'Point_11': '0.0,0.0'},
   'VNomEff': '875.0,1100.0,1300.0,',
   'EfficMaxV': '99.030,98.860,98.690,',
   'EfficEuroV': '98.810,98.627,98.421,',
   'ProfilPIOV1': {'NPtsMax': '11',
    'NPtsEff': '9',
    'LastCompile': '$8089',
    'Mode': '1',
    'Point_1': '3125.0,0.0',
    'Point_2': '163952.7,159280.0',
    'Point_3': '320420.6,315390.0',
    'Point_4': '635380.4,628010.0',
    'Point_5': '792268.9,783950.0',
    'Point_6': '949459.8,940250.0',
    'Point_7': '1580566.0,1563970.0',
    'Point_8': '2370556.7,2342110.1',
    'Point_9': '3155956.3,3115560.1',
    'Point_10': '0.0,0.0',
    'Point_11': '0.0,0.0'},
   'ProfilPIOV2': {'NPtsMax': '11',
    'NPtsEff': '9',
    'LastCompile': '$8089',
    'Mode': '1',
    'Point_1': '3125.0,0.0',
    'Point_2': '164523.1,158880.0',
    'Point_3': '321647.8,315440.0',
    'Point_4': '636356.2,627320.0',
    'Point_5': '793900.1,783500.0',
    'Point_6': '950465.2,939630.0',
    'Point_7': '1582454.6,1563939.9',
    'Point_8': '2372756.9,2342860.1',
    'Point_9': '3170945.7,3124649.9',
    'Point_10': '0.0,0.0',
    'Point_11': '0.0,0.0'},
   'ProfilPIOV3': {'NPtsMax': '11',
    'NPtsEff': '9',
    'LastCompile': '$8089',
    'Mode': '1',
    'Point_1': '3125.0,0.0',
    'Point_2': '165697.0,158920.0',
    'Point_3': '323254.1,315690.0',
    'Point_4': '637521.6,627640.0',
    'Point_5': '795473.8,783860.0',
    'Point_6': '952507.9,940030.0',
    'Point_7': '1585300.1,1563740.0',
    'Point_8': '2376773.2,2342310.1',
    'Point_9': '3177379.0,3125270.0',
    'Point_10': '0.0,0.0',
    'Point_11': '0.0,0.0'}},
  'NbInputs': '18',
  'NbMPPT': '2',
  'TanPhiMin': '-0.750',
  'TanPhiMax': '0.750',
  'NbMSInterne': '2',
  'MasterSlave': 'No_M_S',
  'IsolSurvey ': 'Yes',
  'DC_Switch': 'Yes',
  'AC_Switch': 'Yes',
  'DiscAdjust': 'Yes',
  'MS_Thresh': '0.8',
  'Night_Loss': '120.00'}}
```

How to use the resulting dictionaries with the inverter and module parameters is a different story, better left for another post.
