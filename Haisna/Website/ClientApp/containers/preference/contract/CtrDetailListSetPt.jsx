import React from 'react';
import CtrDetailListSetPtHeaderForm from './CtrDetailListSetPtHeaderForm';
import CtrDetailListSetPtBody from './CtrDetailListSetPtBody';

const CtrDetailListSetPt = (props) => (
  <div>
    <CtrDetailListSetPtHeaderForm />
    <CtrDetailListSetPtBody {...props} />
  </div>
);

export default CtrDetailListSetPt;

