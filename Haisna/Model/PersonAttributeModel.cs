using System;

#pragma warning disable CS1591

namespace Hainsi.Entity.Model
{
    public class PersonAttributeModel
    {
        public string PerId { get; set; }
        public int VidFlg { get; set; }
        public int DelFlg { get; set; }
        public string UpdUser { get; set; }
        public DateTime Birth { get; set; }
        public int Gender { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FirstKName { get; set; }
        public string LastKName { get; set; }
        public string RomeName { get; set; }
        public string MedRName { get; set; }
        public string MedName { get; set; }
        public DateTime MedBirth { get; set; }
        public int MedGender { get; set; }
        public int PostCardAddr { get; set; }
        public string MedNationCd { get; set; }
        public string MedKName { get; set; }
        public int AddrDiv { get; set; }
        public string ZipCd { get; set; }
        public string PrefCd { get; set; }
        public string CityName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Tel1 { get; set; }
        public string Phone { get; set; }
        public string Tel2 { get; set; }
        public string Extension { get; set; }
    }
}
