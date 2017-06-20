// Copyright © 2017 Iain Nicol

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.

use std::ffi::OsStr;
use std::iter;
use std::io;
use std::io::Write;
use std::mem;
use std::os::windows::ffi::OsStrExt;
use std::ptr;

use user32;
use winapi;
use winapi::oaidl::VARIANT;

use winapi::{winerror, wtypes};
use winapi::oaidl::VARIANTARG;
use winapi::wtypes::VARTYPE;



extern "system" {
    fn VariantClear(pvarg: *mut VARIANTARG);
    fn VariantCopy(pvargDest: *mut VARIANTARG, pvargSrc: *const VARIANTARG);
    // Don't alias src and dest, else the src will be mutated.  Yet we're saying it's const.
    fn VariantChangeType(pvargDest: *mut VARIANTARG,
                         pvarSrc: *const VARIANTARG,
                         wFlags: winapi::USHORT,
                         vt: VARTYPE)
                         -> winerror::HRESULT;
}


fn encode_wide(s: &str) -> Vec<u16> {
    OsStr::new(s).encode_wide().chain(iter::once(0)).collect()
}





#[allow(non_snake_case)]
#[no_mangle]
// TODO: implement this function against the correct prototype.
// Currently we implement only the first parameter.
// Also, the return type is wrong.
pub extern "system" fn MsgBox(prompt: *const VARIANT) {
    let mut promptCoerced: VARIANT = unsafe { mem::zeroed() };
    unsafe {
        VariantChangeType(&mut promptCoerced, prompt, 0, wtypes::VT_BSTR.0 as VARTYPE);
        if promptCoerced.vt() != &(wtypes::VT_BSTR.0 as VARTYPE) {
            return;
        }
        let msg = *promptCoerced.bstrVal();
        let project1 = encode_wide("Project1 (WOO)");
        user32::MessageBoxW(
            ptr::null_mut(),
            msg,
            project1.as_ptr(),
            winapi::MB_OK,
        )
    };
}
