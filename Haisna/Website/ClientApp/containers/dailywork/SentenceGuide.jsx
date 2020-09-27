import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { compose, withState } from 'recompose';

import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';

import { OcrNyuryokuBody } from '../../constants/common';

const constantsSpBody201210 = OcrNyuryokuBody.OcrNyuryokuSpBody201210;
const constantsBody = OcrNyuryokuBody.OcrNyuryokuBody;
const constantsSpBody = OcrNyuryokuBody.OcrNyuryokuSpBody;
const constantsSpBody2 = OcrNyuryokuBody.OcrNyuryokuSpBody2;

// eslint-disable-next-line react/prop-types
const Guide = ({ setChgRsl, actions }: { actions: typeof sentenceGuideActions }) => (
  <div>
    <a
      role="presentation"
      style={{ cursor: 'pointer' }}
      onClick={() =>
        actions.sentenceGuideOpenRequest({
          itemCd: '30960',
          itemType: 0,
          onConfirm: (data) => {
            if (document.getElementById('OpeNameSpBody201210')) {
              setChgRsl(constantsSpBody201210.OCRGRP_START10 + 0, data.stcCd);
              document.getElementById('OpeNameSpBody201210').innerHTML = data.shortStc;
            } else if (document.getElementById('OpeNameBody')) {
              setChgRsl(constantsBody.OCRGRP_START9 + 0, data.stcCd);
              document.getElementById('OpeNameBody').innerHTML = data.shortStc;
            } else if (document.getElementById('OpeNameSpBody')) {
              setChgRsl(constantsSpBody.OCRGRP_START10 + 0, data.stcCd);
              document.getElementById('OpeNameSpBody').innerHTML = data.shortStc;
            } else if (document.getElementById('OpeNameSpBody2')) {
              setChgRsl(constantsSpBody2.OCRGRP_START10 + 0, data.stcCd);
              document.getElementById('OpeNameSpBody2').innerHTML = data.shortStc;
            }
          },
        })
      }
    >
      <span style={{ color: 'blue' }}>?</span>
    </a>
  </div>
);

export default compose(
  withState('selectedItem', 'setSelectedItem', null),
  connect(
    null,
    (dispatch) => ({
      actions: bindActionCreators(sentenceGuideActions, dispatch),
    }),
  ),
)(Guide);
