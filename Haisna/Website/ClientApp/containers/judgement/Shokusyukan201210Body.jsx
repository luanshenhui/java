import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { openMenFoodCommentGuide, calcRequest } from '../../modules/judgement/interviewModule';
import MessageBanner from '../../components/MessageBanner';

const FloatDiv = styled.div`
  float: left;
  white-space: nowrap;
`;
const handleClick = (params, calc) => {
  // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
  // eslint-disable-next-line no-alert,no-restricted-globals
  if (!confirm('食習慣点数計算をします。よろしいですか？')) {
    return false;
  }
  calc(params);
  return false;
};
const Shokusyukan201210Body = (props) => {
  const { match, data, arrFoodCmtCnt, onOpenMenFoodCommentGuide, message, calc } = props;
  const { params } = match;
  return (
    <div>
      <div style={{ overflow: 'hidden', width: '950px' }}>
        <a href="#" style={{ float: 'left' }}>OCR入力結果確認</a>
        <a href="#" style={{ float: 'right', marginLeft: '20px' }} onClick={() => { onOpenMenFoodCommentGuide(params); }}>食習慣問診コメント入力</a>
        <a href="#" style={{ float: 'right' }} onClick={() => { handleClick(params, calc); }}>食習慣点数再計算</a>
      </div>
      {message !== '' &&
        <MessageBanner message={[message]} />
      }
      <div style={{ overflow: 'hidden', marginTop: '20px' }}>
        <div style={{ float: 'left' }}>
          <div style={{ backgroundColor: '#eeeeee' }}><b>１．食べ方について</b></div>
          {data.map((res, index) => {
            if (index < 4) {
              let strColor = '';
              if (res.healthpoint === '-2') {
                strColor = '#fda9b8';
              } else if (res.healthpoint === '-1') {
                strColor = '#fed5dd';
              } else {
                strColor = '#eeeeee';
              }
              return (
                <div style={{ overflow: 'hidden', margin: '2px 0' }} key={index.toString()}>
                  <FloatDiv>{res.itemqname}</FloatDiv>
                  <FloatDiv style={{ backgroundColor: strColor, float: 'right', width: '200px' }}>&nbsp;{res.result}</FloatDiv>
                </div>
              );
            }
            return null;
          })}

          <div style={{ backgroundColor: '#eeeeee' }}><b>２．食習慣について</b></div>
          {data.map((res, index) => {
            if (index >= 4 && index < 11) {
              let strColor = '';
              if (res.healthpoint === '-2') {
                strColor = '#fda9b8';
              } else if (res.healthpoint === '-1') {
                strColor = '#fed5dd';
              } else {
                strColor = '#eeeeee';
              }
              return (
                <div style={{ overflow: 'hidden', margin: '2px 0' }} key={index.toString()}>
                  <FloatDiv>{res.itemqname}</FloatDiv>
                  <FloatDiv style={{ backgroundColor: strColor, float: 'right', width: '200px' }}>&nbsp;{res.result}</FloatDiv>
                </div>
              );
            }
            return null;
          })}


          <div style={{ backgroundColor: '#eeeeee' }}><b>３．食事内容について</b></div>
          {data.map((res, index) => {
            if (index >= 11 && index < 20) {
              let strColor = '';
              if (res.healthpoint === '-2') {
                strColor = '#fda9b8';
              } else if (res.healthpoint === '-1') {
                strColor = '#fed5dd';
              } else {
                strColor = '#eeeeee';
              }
              return (
                <div style={{ overflow: 'hidden', margin: '2px 0' }} key={index.toString()}>
                  <FloatDiv>{res.itemqname}</FloatDiv>
                  <FloatDiv style={{ backgroundColor: strColor, float: 'right', width: '200px' }}>&nbsp;{res.result}</FloatDiv>
                </div>
              );
            }
            return null;
          })}


          <div style={{ backgroundColor: '#eeeeee' }}><b>４．その他の質問</b></div>
          <div style={{ overflow: 'hidden', margin: '2px 0' }}><FloatDiv>栄養相談が必要と思われる場合、ご案内書をお送りしてもよいですか</FloatDiv>
            <FloatDiv style={{ backgroundColor: '#eeeeee', float: 'right', width: '200px' }}>&nbsp;
              {data.map((res, index) => {
                if (index === 20) {
                  return res.result;
                }
                return null;
              })}
            </FloatDiv>
          </div>

        </div>

        <div style={{ float: 'left', marginLeft: '30px' }}>
          <div style={{ backgroundColor: '#eeeeee' }}>食習慣コメント</div>
          <div style={{ minHeight: '200px' }}>
            {arrFoodCmtCnt.length > 0 && arrFoodCmtCnt.map((res, index) => (
              <div key={index.toString()}>{res.judcmtstc}</div>
            ))}
          </div>

          <div style={{ backgroundColor: '#eeeeee' }}>食習慣バランス</div>

          <div><canvas id="cv" width="310" height="250">&nbsp;</canvas></div>

          <div><span style={{ color: 'red' }}>△</span>があなたの食習慣バランスです</div>
          <div><span style={{ color: '#1F477A' }}>△</span>があなたの食習慣バランスです</div>
        </div>
      </div>
    </div>
  );
};

// propTypesの定義
Shokusyukan201210Body.propTypes = {
  match: PropTypes.shape().isRequired,
  message: PropTypes.string.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  arrFoodCmtCnt: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenMenFoodCommentGuide: PropTypes.func.isRequired,
  calc: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  data: state.app.judgement.interview.getShokusyukanList.data,
  message: state.app.judgement.interview.getShokusyukanList.message,
  arrFoodCmtCnt: state.app.judgement.interview.getShokusyukanList.arrFoodCmtCnt,
});
const mapDispatchToProps = (dispatch) => ({
  onOpenMenFoodCommentGuide: (params) => {
    dispatch(openMenFoodCommentGuide({ params }));
  },
  calc: (params) => {
    dispatch(calcRequest(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Shokusyukan201210Body);
