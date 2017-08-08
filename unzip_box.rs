
struct UnzipBox<T, U>
{
    length: u64,
    p_fst: *mut T,
    p_snd: *mut U,
}

impl<T, U> FromIterator<(T, U)>
{
    fn from_iter<I: IntoIterator<Item=i32>>(iter: I) -> Self
    {
        let mut vec_fst = Vec::new();
        let mut vec_snd = Vec::new();
        
        for (fst, snd) in iter
        {
            vec_fst.push(fst);
            vec_snd.push(snd);
        }
        
        let length = vec_fst.len();
        
        unsafe
        {
            UnzipBox
            {
                length: length,
                p_fst: vec_to_ptr(vec_fst),
                p_snd: vec_to_ptr(vec_snd),
            }
        }
    }
}

impl<T, U> Drop for UnzipBox<T, U>
{
    fn drop(&mut self)
    {
        ptr_to_box(self.p_fst, self.length);
        ptr_to_box(self.p_snd, self.length);
    }
}

unsafe fn vec_to_ptr<T>(vec: Vec<T>) -> *mut T
{
    let as_box = vec.into_boxed_slice();
    let as_ref = &mut as_box[0];
    let as_ptr = as_ref as *mut T;
    mem::forget(as_box);
    as_ptr
}
