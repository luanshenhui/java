import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import SectionBar from '../../../components/SectionBar';
import Table from '../../../components/Table';
import { FieldGroup, FieldSet } from '../../../components/Field';

const DispKbn = (data) => {
  let res;
  // 表示対象区分をマークで表示
  switch (data) {
    case 1:
      res = '#ff6666';
      break;
    case 2:
      res = '#6666ff';
      break;
    case 3:
      res = '#66ff66';
      break;
    default:
      break;
  }
  return res;
};

const CommentListBody = ({ pubNoteData, type, params, onOpenCommentDetailGuide }) => (
  <div style={{ height: '200px', overflow: 'auto' }}>
    <FieldGroup>
      {pubNoteData && pubNoteData !== null && pubNoteData.title !== '' && (<SectionBar title={pubNoteData.title} />)}
      <FieldSet>
        <Table striped hover>
          <thead>
            <tr>
              {pubNoteData && pubNoteData !== null && pubNoteData.dataNames.map((rec) => (
                <th key={rec}>
                  {rec}
                </th>
              ))}
            </tr>
          </thead>
          {type !== '3' &&
              type !== '4' &&
              pubNoteData &&
              pubNoteData !== null &&
              pubNoteData.dataContent !== '' &&
              pubNoteData.dataContent !== undefined &&
              pubNoteData.dataContent.map((rec, index) => (
                <tbody key={rec.key}>
                  <tr key={`${rec.key}-${index.toString()}`} style={{ background: rec.delflg === 1 ? '#FFC0CB' : '' }} >
                    <td>{rec.pubnotedivname}</td>
                    <td>
                      <span style={{ color: DispKbn(rec.dispkbn) }}>■</span>
                      {(rec.rsvno === null || Number.parseInt(params.rsvno, 10) === rec.rsvno) ?
                        <a
                          role="presentation"
                          onClick={() => onOpenCommentDetailGuide({ params: { ...params, seq: rec.seq, selinfo: rec.selinfo }, values: { rsvno: rec.rsvno, pubnotedivcd: rec.pubnotedivcd } })}
                        >
                          <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                            {rec.boldflg === 1 &&
                              <strong>{rec.pubnote}</strong>
                            }
                            {rec.boldflg !== 1 &&
                              <span>{rec.pubnote}</span>
                            }
                          </span>
                        </a>
                        :
                        <span style={{ color: `#${rec.dispcolor}` }}>
                          <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                            {rec.boldflg === 1 &&
                              <strong>{rec.pubnote}</strong>
                            }
                            {rec.boldflg !== 1 &&
                              <span>{rec.pubnote}</span>
                            }
                          </span>
                          {rec.pubnote}
                        </span>
                      }
                    </td>
                    <td>{rec.username}</td>
                    <td>{rec.upddate !== null ? moment(rec.upddate).format('YYYY/MM/DD HH:mm:SS') : ''}</td>
                  </tr>
                </tbody>
            ))}
          {type === '3' && pubNoteData && pubNoteData !== null && pubNoteData.dataContent !== '' && pubNoteData.dataContent !== undefined && pubNoteData.dataContent.map((rec) => (
            <tbody key={rec.key}>
              <tr key={rec.key} style={{ background: rec.delflg === 1 ? '#FFC0CB' : '' }} >
                <td>{rec.pubnotedivname}</td>
                <td>{rec.csldate !== null ? moment(rec.csldate).format('YYYY/MM/DD') : ''}</td>
                <td>
                  <span style={{ color: DispKbn(rec.dispkbn) }}>■</span>
                  {(rec.rsvno === null || Number.parseInt(params.rsvno, 10) === rec.rsvno) ?
                    <a
                      role="presentation"
                      onClick={() => onOpenCommentDetailGuide({ params: { ...params, seq: rec.seq, selinfo: rec.selinfo }, values: { rsvno: rec.rsvno, pubnotedivcd: rec.pubnotedivcd } })}
                    >
                      <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                        {rec.boldflg === 1 &&
                          <strong>{rec.pubnote}</strong>
                        }
                        {rec.boldflg !== 1 &&
                          <span>{rec.pubnote}</span>
                        }
                      </span>
                    </a>
                    :
                    <span style={{ color: `#${rec.dispcolor}` }}>
                      <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                        {rec.boldflg === 1 &&
                          <strong>{rec.pubnote}</strong>
                        }
                        {rec.boldflg !== 1 &&
                          <span>{rec.pubnote}</span>
                        }
                      </span>
                      {rec.pubnote}
                    </span>
                  }
                </td>
                <td>{rec.csname}</td>
                <td>{rec.username}</td>
                <td>{rec.upddate !== null ? moment(rec.upddate).format('YYYY/MM/DD HH:mm:SS') : ''}</td>
              </tr>
            </tbody>
          ))}
          {type === '4' && pubNoteData && pubNoteData !== null && pubNoteData.dataContent !== '' && pubNoteData.dataContent !== undefined && pubNoteData.dataContent.map((rec) => (
            <tbody key={rec.key}>
              <tr key={rec.key}>
                <td>{rec.pubnotedivname}</td>
                <td>{rec.rsvno === null ? '個人' : '受診歴'}</td>
                <td>{rec.csldate !== null ? moment(rec.csldate).format('YYYY/MM/DD') : ''}</td>
                <td>
                  <span style={{ color: DispKbn(rec.dispkbn) }}>■</span>
                  {(rec.rsvno === null || Number.parseInt(params.rsvno, 10) === rec.rsvno) ?
                    <a
                      role="presentation"
                      onClick={() => onOpenCommentDetailGuide({ params: { ...params, seq: rec.seq, selinfo: rec.selinfo }, values: { rsvno: rec.rsvno, pubnotedivcd: rec.pubnotedivcd } })}
                    >
                      <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                        {rec.boldflg === 1 &&
                          <strong>{rec.pubnote}</strong>
                        }
                        {rec.boldflg !== 1 &&
                          <span>{rec.pubnote}</span>
                        }
                      </span>
                    </a>
                    :
                    <span style={{ color: `#${rec.dispcolor}` }}>
                      <span style={{ color: rec.dispcolor === null ? '#006699' : `#${rec.dispcolor}` }}>
                        {rec.boldflg === 1 &&
                          <strong>{rec.pubnote}</strong>
                        }
                        {rec.boldflg !== 1 &&
                          <span>{rec.pubnote}</span>
                        }
                      </span>
                      {rec.pubnote}
                    </span>
                  }
                </td>
                <td>{rec.username}</td>
                <td>{rec.upddate !== null ? moment(rec.upddate).format('YYYY/MM/DD HH:mm:SS') : ''}</td>
              </tr>
            </tbody>
          ))}
        </Table>
      </FieldSet>
    </FieldGroup>
  </div>
);


// propTypesの定義
CommentListBody.propTypes = {
  pubNoteData: PropTypes.shape(),
  type: PropTypes.string,
  params: PropTypes.shape().isRequired,
  onOpenCommentDetailGuide: PropTypes.func,
};

CommentListBody.defaultProps = {
  type: null,
  pubNoteData: null,
  onOpenCommentDetailGuide: null,
};

export default CommentListBody;
