import React from 'react';
import PropTypes from 'prop-types';
import SpJudCommentGuide from './SpJudCommentGuide';
import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';

const SpecialJudViewBody2 = ({ data, onOpenSpJudCommentGuide, rsvno }) => (
  <div>
    <div>
      <SectionBar title="階層化コメント" />
      <Button onClick={() => { onOpenSpJudCommentGuide({ rsvno }); }} value="コメント修正" />
    </div>
    <div style={{ marginTop: 10 }} >
      {data && data.map((rec, index) => (
        <div key={index.toString()}>{rec.judcmtstc}</div>
      ))}
    </div>
    <SpJudCommentGuide />
  </div>
);

// propTypesの定義
SpecialJudViewBody2.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenSpJudCommentGuide: PropTypes.func.isRequired,
  rsvno: PropTypes.string.isRequired,
};

export default SpecialJudViewBody2;
