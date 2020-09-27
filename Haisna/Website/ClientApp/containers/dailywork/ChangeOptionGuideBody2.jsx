import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Table from '../../components/Table';
import Chip from '../../components/Chip';
import GuideButton from '../../components/GuideButton';

const Wrapper = styled.div`
  white-space: nowrap;
`;

const WrapperDel = styled.div`
  white-space: nowrap;
  font-weight: bold;
  font-color: #cccccc;
`;

const EditComment = (data) => {
  const { changesetdata, onDelete, handleClickGuide } = data;
  const { count, grpname, consults, rslcmtname } = changesetdata;
  const res = [];
  const arrgrpname = [];
  const arrconsults = [];
  const arrrslcmtname = [];
  let resCommentList = [];
  let num = 0;

  while (num < count && count > 0) {
    arrgrpname[num] = grpname[num];
    arrconsults[num] = consults[num];
    arrrslcmtname[num] = rslcmtname[num];
    num += 1;
  }

  // 読み込んだオプション検査情報の検索
  if (count > 0) {
    for (let i = 0; i < count; i += 1) {
      resCommentList = [];
      if (arrconsults[i] !== '') {
        resCommentList.push(<td style={{ border: '1px solid #ccc' }} key={i + 1}><Wrapper>{arrgrpname[i]}</Wrapper></td>);
        resCommentList.push(<td style={{ borderWidth: '0 1px #ccc' }} key={i + 2}><GuideButton onClick={() => handleClickGuide(i)} /></td>);
        resCommentList.push(<td style={{ borderWidth: '0 1px #ccc' }} key={i + 3}><Chip onDelete={() => onDelete(i)} /></td>);
        resCommentList.push(<td style={{ borderRight: '1px solid #ccc' }} key={i + 4}><Wrapper>{arrrslcmtname[i]}</Wrapper></td>);
      } else {
        resCommentList.push(<td style={{ border: '1px solid #ccc' }} key={i + 1}><WrapperDel><del>{arrgrpname[i]}</del></WrapperDel></td>);
        resCommentList.push(<td style={{ borderWidth: '0 1px #ccc' }} key={i + 2}>&nbsp;</td>);
        resCommentList.push(<td style={{ borderWidth: '0 1px #ccc' }} key={i + 3}>&nbsp;</td>);
        resCommentList.push(<td style={{ borderRight: '1px solid #ccc', width: 260 }} key={i + 4}>&nbsp;</td>);
      }
      res.push(<tr style={{ background: 'white', fontSize: '13px' }} key={i}>{resCommentList}</tr>);
    }
  }
  return res;
};


const ChangeOptionGuideBody2 = ({ changesetdata, onDelete, handleClickGuide }) => (
  <div>
    <Table>
      <thead>
        <tr style={{ background: '#e0e0e0', height: '15px', fontSize: '13px' }}>
          <td style={{ border: '1px' }}>検査セット名</td>
          <td colSpan="3" style={{ border: '1px' }}>検査コメント</td>
        </tr>
      </thead>
      <tbody>
        <EditComment changesetdata={changesetdata} onDelete={onDelete} handleClickGuide={handleClickGuide} />
      </tbody>
    </Table>
  </div>
);

// propTypesの定義
ChangeOptionGuideBody2.propTypes = {
  changesetdata: PropTypes.shape().isRequired,
  handleClickGuide: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};

export default ChangeOptionGuideBody2;
